function gg --description 'Pretty git log graph, all refs'
    git log --graph --all --abbrev-commit \
        --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' $argv
end
