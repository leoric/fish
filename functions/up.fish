function up --description 'cd up N directories (default 1)'
    set -l count 1
    set -q argv[1]; and set count $argv[1]
    if not string match -qr '^\d+$' -- $count
        echo "up: '$count' is not a number" >&2
        return 1
    end
    test $count -gt 0; and cd (string repeat -n $count ../)
end
