function _git_log_prettily
    if test -n "$argv[1]"
        git log --pretty=$argv[1]
    end
end
