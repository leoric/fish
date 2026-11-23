function ff --description 'ffmpeg re-encode: ff <file> [start [end|duration]] [264] [720] [-q N] [-vf filter] [extra ffmpeg args]'
    if not set -q argv[1]
        echo "Usage: ff <file> [start [end]] [264] [720] [-q N] [-vf filter] [ffmpeg args]" >&2
        return 1
    end
    set -l input_file $argv[1]
    set -e argv[1]

    # Shared with the _ff_* helpers (they run with --no-scope-shadowing)
    set -l codec
    set -l vf_stack
    set -l extra_args
    set -l start_mark ''
    set -l end_mark ''
    set -l to_flag 0
    set -l q ''
    set -l use264 0
    set -l use720 0
    set -l src_codec ''
    set -l src_w ''
    set -l src_h ''
    set -l src_short ''
    set -l src_br ''
    set -l fps ''
    set -l enc ''
    set -l out_ext ''
    set -l consumed 0

    _ff_parse_time $argv
    test $consumed -gt 0; and set -e argv[1..$consumed]
    _ff_probe
    _ff_parse_flags $argv; or return 1
    _ff_pick_codec
    _ff_pick_quality; or return 1

    set -l out (path change-extension '' -- $input_file)_.$out_ext
    set -l cmd ffmpeg -hide_banner -i $input_file $codec
    test -n "$start_mark"; and set -a cmd -ss $start_mark
    if test -n "$end_mark"
        if test $to_flag -eq 1
            set -a cmd -to $end_mark
        else
            set -a cmd -t $end_mark
        end
    end
    if set -q vf_stack[1]
        set -a cmd -vf (string join , $vf_stack)
    end
    set -a cmd $extra_args -y $out

    printf 'Executing:'
    printf ' %s' (string escape -- $cmd)
    echo
    $cmd
end
