function pk --description 'Pack: pk <tbz|tgz|txz|tar|bz2|gz|zip|7z> <file-or-dir>'
    if test (count $argv) -lt 2
        echo "Usage: pk <tbz|tgz|txz|tar|bz2|gz|zip|7z> <file-or-dir>"
        return 1
    end
    set -l t $argv[2]
    switch $argv[1]
        case tbz
            tar cjvf $t.tar.bz2 $t
        case tgz
            tar czvf $t.tar.gz $t
        case txz
            tar cJvf $t.tar.xz $t
        case tar
            tar cpvf $t.tar $t
        case bz2
            bzip2 $t
        case gz
            gzip -c -9 -n $t >$t.gz
        case zip
            zip -r $t.zip $t
        case 7z
            7z a $t.7z $t
        case '*'
            echo "'$argv[1]' cannot be packed via pk()"
            return 1
    end
end
