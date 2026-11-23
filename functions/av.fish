function av --description 'Fixed-quality AVIF encode: av [-q quality] <file>'
    argparse -n av 'q=' -- $argv; or begin
        echo "Usage: av [-q quality] <file>" >&2
        return 1
    end

    set -l q 90
    set -q _flag_q; and set q $_flag_q

    if not set -q argv[1]
        echo "Usage: av [-q quality] <file>" >&2
        return 1
    end
    if not string match -qr '^\d+$' -- $q; or test $q -gt 100
        echo "av: quality must be an integer 0-100" >&2
        return 1
    end
    if not test -f $argv[1]
        echo "av: not a file: $argv[1]" >&2
        return 1
    end
    if not type -q avifenc
        echo "av: 'avifenc' not found in PATH" >&2
        return 1
    end

    set -l output_name (_av_name $argv[1])
    test -n "$output_name"; or return 1

    if not avifenc -q $q --qalpha 100 -s 0 $argv[1] $output_name.avif
        echo "av: AVIF encoding failed" >&2
        return 1
    end

    echo "$argv[1] -> $output_name.avif  (fixed q=$q, qalpha=100 -- no SSIMULACRA2 check)"
end
