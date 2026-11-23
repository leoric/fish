function avs --description 'AVIF encode with SSIMULACRA2 quality search'
    if not set -q argv[1]
        echo "Usage: avs <file>" >&2
        return 1
    end
    set -l input $argv[1]
    if not test -f $input
        echo "avs: not a file: $input" >&2
        return 1
    end
    if not type -q avifenc
        echo "avs: 'avifenc' not found in PATH" >&2
        return 1
    end

    # The search needs ssymulacra2 and friends. If any is missing, fall back to
    # fixed-quality `av` instead of failing.
    for c in ssymulacra2 magick mktemp awk tail sed
        if not type -q $c
            printf '\e[1;5;31m*** avs: WARNING: "%s" not found — falling back to av (fixed q=90), no quality check performed ***\e[0m\n' $c >&2
            av -q 90 $input
            return $status
        end
    end

    set -l output_name (_av_name $input)
    test -n "$output_name"; or return 1

    set -l TARGET_SCORE 90
    set -l MIN_Q 60
    set -l MAX_Q 90
    set -l SPEED 0

    set -l tmp /tmp
    test -n "$TMPDIR"; and set tmp (string trim -r -c / -- $TMPDIR)
    set -l work (mktemp -d $tmp/av.XXXXXX)
    if test -z "$work"; or not test -d "$work"
        echo "avs: could not create temp dir" >&2
        return 1
    end

    # Decode once to a canonical PNG: every trial is scored against it and the
    # final AVIF is encoded from it, so the reported score matches the shipped file.
    set -l reference $work/reference.png
    if not magick $input $reference >$work/decode-source.log 2>&1
        echo "avs: could not decode source image" >&2
        sed 's/^/  /' $work/decode-source.log >&2
        rm -rf $work
        return 1
    end

    set -l _av_score ''
    set -l _av_encoded 0
    set -l low $MIN_Q
    set -l high $MAX_Q
    set -l best 0
    set -l best_score ''
    set -l search_ok 1

    if not _av_encode_test $MAX_Q
        set search_ok 0
        set best $MAX_Q
        set best_score n/a
        printf '\e[1;31mavs: WARNING: quality test failed at q=%s -- using q=%s, no quality check performed\e[0m\n' $MAX_Q $MAX_Q >&2
    else if awk -v s=$_av_score -v t=$TARGET_SCORE 'BEGIN { exit !(s >= t) }'
        set best $MAX_Q
        set best_score $_av_score

        while test $low -le $high
            set -l mid (math "floor(($low + $high) / 2)")

            if not _av_encode_test $mid
                echo "avs: quality test failed at q=$mid" >&2
                rm -rf $work
                return 1
            end

            if awk -v s=$_av_score -v t=$TARGET_SCORE 'BEGIN { exit !(s >= t) }'
                set best $mid
                set best_score $_av_score
                set high (math $mid - 1)
            else
                set low (math $mid + 1)
            end
        end
    else
        set best $MAX_Q
        set best_score $_av_score
        echo "avs: WARNING: SSIMULACRA2 $best_score < target $TARGET_SCORE at q=$MAX_Q (using q=$MAX_Q anyway)" >&2
    end

    set -l pre $work/test-$MAX_Q.avif
    if test $search_ok -eq 0; and test $_av_encoded -eq 1; and test -s $pre
        # avifenc already produced a valid q=MAX file; only decode/scoring failed
        if not cp $pre $output_name.avif
            echo "avs: could not copy existing AVIF to $output_name.avif" >&2
            rm -rf $work
            return 1
        end
    else if not avifenc --qcolor $best --qalpha $best -s $SPEED $reference $output_name.avif >$work/final.log 2>&1
        echo "avs: final AVIF encoding failed" >&2
        sed 's/^/  /' $work/final.log >&2
        rm -rf $work
        return 1
    end

    echo "$input -> $output_name.avif  (q=$best, SSIMULACRA2=$best_score)"
    rm -rf $work
end
