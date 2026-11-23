#!/usr/bin/env python3
"""Import a zsh history file into fish's history.

    python3 zsh_history_to_fish.py                 # ~/.zsh_history -> fish history
    python3 zsh_history_to_fish.py -i FILE -o FILE
    python3 zsh_history_to_fish.py --dry-run

Handles zsh's extended format (": 1700000000:0;cmd"), plain lines, multi-line
commands and zsh's "metafied" non-ASCII bytes (Cyrillic etc.). Existing fish
history is kept (backed up first); imported entries go before it, oldest first.
Fish drops duplicate commands itself when it loads the file.
"""
import argparse
import os
import re
import shutil
import sys
import time
from pathlib import Path

HEADER = re.compile(r"^: (\d+):\d+;(.*)$")


def unmetafy(data: bytes) -> bytes:
    """zsh stores bytes like 0x83..0x9f as 0x83 followed by (byte ^ 32)."""
    out = bytearray()
    it = iter(data)
    for b in it:
        if b == 0x83:
            nxt = next(it, None)
            if nxt is not None:
                out.append(nxt ^ 32)
        else:
            out.append(b)
    return bytes(out)


def parse(path: Path):
    text = unmetafy(path.read_bytes()).decode("utf-8", errors="replace")
    fallback = int(path.stat().st_mtime)
    entries = []  # [when, cmd]
    cur = None

    def finish():
        if cur is not None and cur[1].strip():
            entries.append(cur)

    for line in text.split("\n"):
        m = HEADER.match(line)
        if m and (cur is None or not cur[2]):
            finish()
            cur = [int(m.group(1)), m.group(2), False]
        elif cur is not None and cur[2]:
            cur[1] += "\n" + line            # continuation line
        else:
            finish()
            cur = [fallback, line, False]
            fallback += 1
            m = None
        # trailing odd backslash => the command continues on the next line
        body = cur[1]
        n = len(body) - len(body.rstrip("\\"))
        if n % 2 == 1:
            cur[1] = body[:-1]
            cur[2] = True
        else:
            cur[2] = False
    finish()
    return [(w, c) for w, c, _ in entries]


def fish_escape(cmd: str) -> str:
    return cmd.replace("\\", "\\\\").replace("\n", "\\n")


def main():
    data_home = os.environ.get("XDG_DATA_HOME", str(Path.home() / ".local/share"))
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("-i", "--input", default=str(Path.home() / ".zsh_history"))
    ap.add_argument("-o", "--output", default=str(Path(data_home) / "fish/fish_history"))
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    src, dst = Path(args.input).expanduser(), Path(args.output).expanduser()
    if not src.is_file():
        sys.exit(f"no such file: {src}")

    entries = sorted(parse(src), key=lambda e: e[0])
    imported = "".join(f"- cmd: {fish_escape(c)}\n  when: {w}\n" for w, c in entries)
    print(f"{len(entries)} commands read from {src}")
    if args.dry_run:
        sys.stdout.write(imported[:2000])
        return

    existing = dst.read_text(encoding="utf-8", errors="replace") if dst.exists() else ""
    dst.parent.mkdir(parents=True, exist_ok=True)
    if dst.exists():
        backup = dst.with_name(f"{dst.name}.bak.{time.strftime('%Y%m%d%H%M%S')}")
        shutil.copy2(dst, backup)
        print(f"backed up {dst} -> {backup}")
    dst.write_text(imported + existing, encoding="utf-8")
    print(f"wrote {dst}. Open a new fish; `history | head` to check.")


if __name__ == "__main__":
    main()
