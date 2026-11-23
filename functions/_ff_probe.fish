# -> src_codec, src_w, src_h, src_short, src_br, fps (+ fps=30 in vf_stack)
function _ff_probe --no-scope-shadowing
    set -l probe (ffprobe -v error -select_streams v:0 \
        -show_entries stream=codec_name,width,height,bit_rate,r_frame_rate \
        -of default=nw=1 $input_file)
    set src_codec (string match -rg '^codec_name=(.*)$' -- $probe | head -n 1)
    set src_w (string match -rg '^width=(.*)$' -- $probe | head -n 1)
    set src_h (string match -rg '^height=(.*)$' -- $probe | head -n 1)
    set src_br (string match -rg '^bit_rate=(.*)$' -- $probe | head -n 1)
    set -l rate (string match -rg '^r_frame_rate=(.*)$' -- $probe | head -n 1)

    if string match -qr '^\d+$' -- "$src_w"; and string match -qr '^\d+$' -- "$src_h"
        set src_short (math "min($src_w, $src_h)")
    end
    set fps (echo $rate | awk -F/ '{ if ($2) print $1/$2; else print $1 }')

    # mkv/webm: the bitrate may only exist at container level
    if not string match -qr '^\d+$' -- "$src_br"
        set src_br (ffprobe -v error -show_entries format=bit_rate -of default=nw=1:nk=1 $input_file)
    end

    set -l fps_i 0
    test -n "$fps"; and set fps_i (printf '%.0f' $fps)
    test $fps_i -gt 30; and set -a vf_stack fps=30
    return 0
end
