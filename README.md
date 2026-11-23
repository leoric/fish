# fish config

For macOS, Linux and Windows 11 (via WSL2). Needs **fish 3.6 or newer** (4.x recommended).

## Layout

| Here | Installed as | Was |
|---|---|---|
| `config.fish` | `~/.config/fish/config.fish` | interactive part |
| `conf.d/00-env.fish` | `…/conf.d/` | `profile`: Homebrew, locale, pager, `PATH`, `LS_COLORS`, umask |
| `conf.d/10-llm.fish` | `…/conf.d/` | LLM variables |
| `conf.d/11-secrets.fish` | `…/conf.d/` (**copied**, not linked) | empty API-key template |
| `conf.d/20-aliases.fish` … `30-python.fish` | `…/conf.d/` | abbreviations |
| `functions/*.fish` | `…/functions/` | functions |
| `fish_plugins` | `…/fish_plugins` | managed by [fisher](https://github.com/jorgebucaran/fisher) |
| `nvimrc` | `~/.config/nvim/init.vim` |  |
| `scripts/zsh_history_to_fish.py` | *not installed* | one-off history importer |

## Install

```sh
git clone <your-repo-url> ~/fish- && cd ~/fish
./install.sh                # links files, installs fisher + plugins
./install.sh --history      # ...and imports ~/.zsh_history
./install.sh --dry-run      # preview
```

Files are linked one by one, so fisher's plugin files never end up inside the repo.
Existing files are moved to `*.bak.<timestamp>`. Re-running is safe.

Then, optionally, make fish your login shell:

```sh
command -v fish | sudo tee -a /etc/shells && chsh -s "$(command -v fish)"
```

### macOS

```sh
brew install fish zoxide eza neovim fzf the_silver_searcher vivid keychain
```

### Linux

```sh
# Debian/Ubuntu (22.04 ships fish 3.3, too old; use the PPA)
sudo apt-add-repository ppa:fish-shell/release-4 && sudo apt update
sudo apt install fish git fzf silversearcher-ag keychain neovim
```
zoxide, eza and vivid: install from their releases or your package source.
Fedora: `sudo dnf install fish`. Arch: `sudo pacman -S fish`.

### Windows 11

fish has no native Windows build. Use WSL2, which is a real Linux install and the supported path:

1. In PowerShell (admin): `wsl --install -d Ubuntu`, reboot, create your user.
2. Inside Ubuntu, follow the Linux steps above. **Clone the repo into the Linux home (`~/`), not `/mnt/c/...`**: symlinks and speed are poor on the Windows drive.
3. Windows Terminal → Settings → your Ubuntu profile → install a Nerd Font and set it as the font.
4. `chsh -s "$(command -v fish)"` inside WSL.

Alternative: MSYS2 (`pacman -S fish`). It works, but set `MSYS=winsymlinks:nativestrict` with Developer Mode on, or use `./install.sh --copy`. Native Windows Neovim reads `%LOCALAPPDATA%\nvim\init.vim`; the installer handles that path under MSYS.

## What changed, and why

**Aliases became abbreviations.** In fish an `alias` is a global function, so `alias grep 'grep -E'` or `alias du 'du -h'` would also change what fish's own scripts and plugins get when they call `grep`/`du`. Abbreviations expand as you type, only at the prompt, and show the real command. The exception is `eza`, which keeps its flags in an alias because only you call it. Abbreviations don't apply inside scripts or functions; use the full command there.

**zsh global aliases (`G`, `L`, `H`, `N`, …)** are `abbr --position anywhere`. Like before, a bare `L` or `G` expands wherever it appears as a word. (In the zsh file `T` was defined twice; the later `|tail` won and is kept.)

**Platform handling added.** `brew shellenv` is tried for Apple Silicon, Intel macOS and Linuxbrew. The clipboard helper (`_clip_paste`) replaces the macOS-only `pbpaste` in `wp`/`av` (uses wl-paste, xclip, xsel or `powershell.exe` on WSL). In `ff`/`ff1`, VideoToolbox encoders are used on macOS and libx264/libx265 elsewhere (`-q` is VideoToolbox-only). `factorio_deploy` takes `FACTORIO_MODS_DIR`, `FACTORIO_STORE_DIR`, `FACTORIO_LAUNCH_CMD`. `dc` falls back to `docker compose` when `docker-compose` isn't installed. `subl` finds Sublime on macOS or Linux. Missing tools (`zoxide`, `nvim`, `brew`, `apt`) no longer produce startup errors.


## Things to review

- **`ag`** is an abbreviation for `abbr --show | grep` (was `alias | grep`). It shadows the_silver_searcher's `ag` at the prompt. fzf still finds the real `ag` because the abbreviation only exists in the interactive prompt.
- **`ANTHROPIC_BASE_URL`** routes API traffic through a third-party host. Keep it only if intended (`conf.d/10-llm.fish`).
- **keychain** loads `id_rsa`; change it in `config.fish` if you use `id_ed25519`.
- **`PRO_PROJECT_ROOT` / `PRO_VENV`** in `00-env.fish` drive the automatic venv switching on `cd`. `PATH` entries that don't exist on a machine are skipped automatically.
- **Alt-E** is rebound to end-of-line (as before); fish's "edit command in $EDITOR" stays on Alt-V.
- **Secrets**: `install.sh` copies `11-secrets.fish` once (mode 600) and never overwrites it, so fill in the keys in `~/.config/fish/conf.d/11-secrets.fish`, not in the repo. Other per-machine bits go in `~/.config/fish/local.fish`.
- Install `fzf` ≥ 0.48 for Ctrl-R / Ctrl-T / Alt-C (`fzf --fish`).

## Day to day

```sh
fisher update                 # install/update plugins from fish_plugins
fisher install owner/repo     # add a plugin (appends to fish_plugins)
abbr --show | grep git        # list abbreviations
fish_update_completions       # regenerate completions from man pages
exec fish                     # reload after editing
```
New function: drop `name.fish` into `functions/` and rerun `./install.sh`.

## Uninstall

```sh
rm -rf ~/.config/fish           # then restore any *.bak.* files from the install
chsh -s "$(command -v zsh)"
```
