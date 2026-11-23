function ff1 --description 'One-second 360p preview clip: ff1 <file> [start]'
    if not set -q argv[1]
        echo "Usage: ff1 <file> [start]" >&2
        return 1
    end
    set -l input $argv[1]

    # VideoToolbox is macOS-only; use software x264 elsewhere
    set -l vcodec h264_videotoolbox
    test (uname) = Darwin; or set vcodec libx264
    set -l codec -c:v $vcodec -crf 31
    set -l vf_stack "scale=-1:360"

    set -l second_arg "$argv[2]"
    if string match -q '*:*' -- "$argv[2]"
        set second_arg "00:$argv[2]"
    end

    set -l out (path change-extension '' -- $input)_1.mp4
    set -l cmd ffmpeg -hide_banner -i $input $codec -c:a copy -preset fast -t 1
    test -n "$second_arg"; and set -a cmd -ss $second_arg
    set -a cmd -vf (string join , $vf_stack) -y $out

    echo -n "Executing:"
    for arg in $cmd
        if test "$arg" = "$input"; or test "$arg" = "$out"
            printf ' "%s"' $arg
        else
            printf ' %s' $arg
        end
    end
    echo

    $cmd
end
