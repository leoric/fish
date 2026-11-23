# Appends -q:v or -b:v to codec (in ff's scope)
function _ff_pick_quality --no-scope-shadowing
    set -l mac 0
    test (uname) = Darwin; and set mac 1

    if test -n "$q"; and test "$enc" != hevc
        echo "ff: -q is only for hevc, ignoring" >&2
        set q ''
    end
    if test -n "$q"; and test $mac -eq 0
        echo "ff: -q is a VideoToolbox option (macOS only), ignoring" >&2
        set q ''
    end

    if test -n "$q"
        set -a codec -q:v $q
        return 0
    end

    if not string match -qr '^\d+$' -- "$src_br"; or not string match -qr '^\d+$' -- "$src_short"
        if test $enc = hevc
            if test $mac -eq 1
                echo "ff: couldn't read source bitrate, falling back to -q:v 50" >&2
                set -a codec -q:v 50
            else
                echo "ff: couldn't read source bitrate, falling back to -crf 28" >&2
                set -a codec -crf 28
            end
            return 0
        end
        echo "ff: couldn't read source bitrate" >&2
        return 1
    end

    # hevc: 65% of the source bitrate, h264/av1: 100%
    set -l factor 1
    test $enc = hevc; and set factor 0.65

    # correct for the pixel count after scaling to 720 on the short side
    set -l ratio 1
    if test $use720 -eq 1; and test $src_short -gt 720
        set ratio (awk -v s=$src_short 'BEGIN{ r=720/s; printf "%.6f", r*r }')
    end

    set -l kbps (awk -v b=$src_br -v f=$factor -v r=$ratio 'BEGIN{ printf "%d", b*f*r/1000 }')
    test $kbps -lt 100; and set kbps 100
    set -a codec -b:v "$kbps"k
    return 0
end
