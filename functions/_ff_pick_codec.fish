# -> enc (h264|av1|hevc), out_ext, codec (in ff's scope)
# VideoToolbox encoders on macOS, software x264/x265 everywhere else.
function _ff_pick_codec --no-scope-shadowing
    set -l common -r 23.98 -c:a aac -b:a 64k -ar 44100 -color_range pc -sws_flags lanczos
    set -l mac 0
    test (uname) = Darwin; and set mac 1

    if test $use264 -eq 1
        set enc h264
        set out_ext mp4
        if test $mac -eq 1
            set codec -c:v h264_videotoolbox -pix_fmt nv12
        else
            set codec -c:v libx264 -pix_fmt yuv420p
        end
    else if test "$src_codec" = av1
        set enc av1
        set out_ext mkv
        set codec -c:v libsvtav1 -pix_fmt yuv420p      # svtav1 can't do nv12
    else
        set enc hevc
        set out_ext mp4
        if test $mac -eq 1
            set codec -c:v hevc_videotoolbox -tag:v hvc1 -pix_fmt nv12
        else
            set codec -c:v libx265 -tag:v hvc1 -pix_fmt yuv420p
        end
    end

    test $out_ext = mp4; and set -a common -movflags +faststart
    set -a codec $common
end
