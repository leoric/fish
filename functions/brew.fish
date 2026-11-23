function brew --description 'brew, forgiving of the "isntall" typo'
    if test "$argv[1]" = isntall
        set -e argv[1]
        command brew install $argv
    else
        command brew $argv
    end
end
