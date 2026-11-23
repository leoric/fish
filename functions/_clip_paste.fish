function _clip_paste --description 'Print clipboard text (macOS, Wayland, X11, WSL)'
    if type -q pbpaste
        pbpaste
    else if type -q wl-paste; and set -q WAYLAND_DISPLAY
        wl-paste --no-newline
    else if type -q xclip
        xclip -selection clipboard -o
    else if type -q xsel
        xsel --clipboard --output
    else if type -q powershell.exe
        powershell.exe -NoProfile -Command Get-Clipboard | string replace -a \r ''
    else
        echo "no clipboard tool found (pbpaste, wl-paste, xclip, xsel, powershell.exe)" >&2
        return 1
    end
end
