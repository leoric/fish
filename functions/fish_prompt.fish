function fish_prompt
end # In case this file gets loaded non-interactively, e.g by conda
status is-interactive || exit

# Transient prompt
function _transient_prompt --on-event fish_preexec
    set -g _transient_command $argv
end

function _transient_postexec --on-event fish_postexec
    set -g _transient_last_status $status
    set -g _transient_active 1
    commandline -f repaint
end

function fish_prompt
    if set -q _transient_active
        set -e _transient_active

        # Clear the previous prompt line
        echo -n \e\[0J

        # Compact transient prompt
        set_color brblack
        date '+%H:%M:%S'
        set_color normal
        echo -n '❯ '
        return
    end

    starship prompt
end
