# General shortcuts (was: alias.zsh).
#
# These are abbreviations, not aliases. In fish an alias is a global function,
# so `alias grep 'grep -E'` or `alias du 'du -h'` would also change what fish's
# own scripts and plugins get when they call grep/du. Abbreviations expand
# while you type, only in the interactive prompt, and show you the real command.
status is-interactive; or return

abbr -a alais alias
abbr -a ag 'abbr --show | grep'      # NB: shadows the_silver_searcher's `ag` at the prompt
abbr -a h history

if type -q nvim
    abbr -a vim nvim
    abbr -a vi nvim
end

if type -q eza
    # eza keeps its flags in an alias-function; only you call it, so that's safe
    alias eza 'eza --git --icons --color=auto --classify=auto --color-scale=all'
    abbr -a ls eza
    abbr -a lt 'eza --tree'
    abbr -a ll 'eza -A'
    abbr -a la 'eza -a'
    abbr -a l1 'eza -1'
    abbr -a l 'eza -la'
    abbr -a lg 'eza -a | grep'
else
    set -l _ls ls --color=auto -F
    test (uname) = Darwin; and set _ls ls -GF    # BSD ls has no --color
    abbr -a ls (string join -- ' ' $_ls)
    abbr -a ll (string join -- ' ' $_ls -A)
    abbr -a la (string join -- ' ' $_ls -a)
    abbr -a l1 (string join -- ' ' $_ls -1)
    abbr -a l (string join -- ' ' $_ls -al)
    abbr -a lg (string join -- ' ' $_ls -a)' | grep'
end

abbr -a md 'mkdir -p'
abbr -a rd rmdir

abbr -a _ sudo
abbr -a please sudo
abbr -a cpr 'cp -r'
abbr -a cps 'sudo cp -r'
abbr -a rms 'sudo rm -r'
abbr -a mvs 'sudo mv'
# use nvim when that's what you run
type -q nvim; and abbr -a vis 'sudo nvim'; or abbr -a vis 'sudo vim'

if type -q brew
    abbr -a bi 'brew install'
    abbr -a br 'brew remove'
    abbr -a bd 'brew doctor'
    abbr -a bc 'brew cleanup --prune=all'
end

if type -q apt
    abbr -a apti 'sudo apt install'
    abbr -a aptu 'sudo apt update'
    abbr -a aptr 'sudo apt remove'
    abbr -a apta 'sudo apt autoremove'
    abbr -a aptp 'sudo apt purge'
end

abbr -a grep 'grep -E'
abbr -a cal 'cal -m'
abbr -a df 'df -h'
abbr -a du 'du -h'

abbr -a tm tmux
abbr -a tma 'tmux att -t'
abbr -a tmaa 'tmux att -t 0'
abbr -a psa 'ps afux'
abbr -a psg 'ps aux | grep'

abbr -a fp ffprobe
abbr -a dv yt-dlp
abbr -a commit 'commit --timeout 30s'
