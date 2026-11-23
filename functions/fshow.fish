function fshow --description 'Browse git log with fzf; Enter shows the commit'
    git log --graph --color=always \
        --format="%C(auto)%h%d %s %C(green)%cr%C(reset)" $argv |
        fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
        --bind "ctrl-m:execute:echo {} | grep -o '[a-f0-9]\{7\}' | head -1 | xargs -I % sh -c 'git show --color=always % | less -R'"
end
