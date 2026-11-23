function fb --description 'Target video bitrate: fb <file> [short-side] [-p percent]'
    set -l input "$argv[1]"
    set -l target 720
    set -l pct 65
    set -q argv[1]; and set -e argv[1]

    while set -q argv[1]
        switch $argv[1]
            case -p
                if not set -q argv[2]
                    echo "fb: -p needs a value" >&2
                    return 1
                end
                set pct $argv[2]
                set -e argv[1]
            case '*'
                string match -qr '^\d+$' -- $argv[1]; and set target $argv[1]
        end
        set -e argv[1]
    end

    if test -z "$input"; or not test -f "$input"
        echo "fb: usage: fb <file> [target] [-p percent]" >&2
        return 1
    end

    set -l probe (ffprobe -v error -select_streams v:0 \
        -show_entries stream=width,height,bit_rate -of default=nw=1 $input)

    set -l w (string match -rg '^width=(.*)$' -- $probe | head -n 1)
    set -l h (string match -rg '^height=(.*)$' -- $probe | head -n 1)
    set -l br (string match -rg '^bit_rate=(.*)$' -- $probe | head -n 1)

    # Fall back to the container bitrate (mkv/webm etc.)
    if not string match -qr '^\d+$' -- "$br"
        set br (ffprobe -v error -show_entries format=bit_rate -of default=nw=1:nk=1 $input)
    end

    if not string match -qr '^\d+$' -- "$br"; or not string match -qr '^\d+$' -- "$w"; or not string match -qr '^\d+$' -- "$h"
        echo "fb: couldn't read width/height/bitrate" >&2
        return 1
    end

    awk -v w=$w -v h=$h -v b=$br -v p=$pct -v t=$target 'BEGIN {
        short = (w < h) ? w : h
        k0 = int(b * (p / 100) / 1000)
        if (k0 < 100) k0 = 100

        if (short > t) {
            r  = t / short
            k1 = int(b * (p / 100) * r * r / 1000)
            if (k1 < 100) k1 = 100
            printf "%d kbps\n%d kbps (%dx%d)\n", k1, k0, w, h
        } else {
            printf "%d kbps\n", k0
        }
    }'
end
