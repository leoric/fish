function gke --description 'gitk including reflog commits'
    command gitk --all (git log -g --pretty=format:%h) $argv
end
