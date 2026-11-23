# Output base name: the clipboard text if the file is called "image" / "image (N)"
# and the clipboard holds a filename-safe string, otherwise the file's own base name.
function _av_name
    set -l base (path change-extension '' -- $argv[1])
    set -l clip (_clip_paste 2>/dev/null | string collect)

    if string match -qr '^image(\s\([0-9]+\))?$' -- $base; and string match -qr '^[a-zA-Z0-9._-]+$' -- $clip
        echo $clip
    else
        echo $base
    end
end
