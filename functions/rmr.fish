function rmr --description 'Recursive delete; confirms once if several read-only files are involved'
    if test (count $argv) -eq 0
        echo "Usage: rmr <file-or-directory> [...]" >&2
        return 2
    end

    # Scan only; delete nothing yet.
    set -l all_files
    set -l ro_files
    command find $argv ! -type d -print0 2>/dev/null | while read -lz f
        set -a all_files $f
        if not test -L $f; and not test -w $f
            set -a ro_files $f
        end
    end

    # 0 or 1 read-only files: plain rm behaviour (its own prompt).
    if test (count $ro_files) -le 1
        command rm -r -- $argv
        return
    end

    # Several read-only files: ask once.
    echo
    echo "Read-only files found ("(count $ro_files)"):"
    printf '  %s\n' $ro_files
    printf '\nDelete all read-only files? [y/N] '
    read -l answer

    if string match -qr '^[yY]$' -- $answer
        command chmod -R -- u+w $argv; and command rm -rf -- $argv
    else
        # Delete only the writable files, keep read-only ones.
        for f in $all_files
            if test -L $f; or test -w $f
                command rm -f -- $f
            end
        end
        command find $argv -depth -type d -empty -delete 2>/dev/null
        echo "Read-only files preserved."
    end
end
