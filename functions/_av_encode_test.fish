# Encode $reference at one quality and score it with SSIMULACRA2.
# Reads $work $reference $SPEED from avs, sets $_av_score and $_av_encoded there.
function _av_encode_test --no-scope-shadowing
    set -l tq $argv[1]
    set -l avif $work/test-$tq.avif
    set -l decoded $work/test-$tq.png

    set _av_encoded 0
    avifenc --qcolor $tq --qalpha $tq -s $SPEED $reference $avif >$work/avifenc-$tq.log 2>&1
    or return 1
    set _av_encoded 1

    magick $avif $decoded >$work/decode-$tq.log 2>&1
    or return 1

    set _av_score (ssymulacra2 $reference $decoded 2>/dev/null | tail -n 1)
    test -n "$_av_score"
end
