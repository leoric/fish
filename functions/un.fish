function un --description 'Extract an archive based on its extension'
    set -l f $argv[1]
    if not test -f "$f"
        echo "'$f' is not a valid file"
        return 1
    end
    switch $f
        case '*.tar.bz2' '*.tbz2'
            tar xjf $f
        case '*.tar.gz' '*.tgz'
            tar xzf $f
        case '*.tar.xz'
            tar xJf $f
        case '*.bz2'
            bunzip2 $f
        case '*.rar'
            unrar x $f
        case '*.gz'
            gunzip $f
        case '*.tar'
            tar xf $f
        case '*.zip'
            unzip $f
        case '*.Z'
            uncompress $f
        case '*.7z'
            7z x $f
        case '*'
            echo "epic fail with '$f'..."
            return 1
    end
end
