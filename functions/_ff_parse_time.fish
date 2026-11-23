# -> start_mark, end_mark, to_flag, consumed (in ff's scope)
function _ff_parse_time --no-scope-shadowing
    set consumed 0
    _ff_is_time $argv[1]; or return 0
    set start_mark (_ff_norm_time $argv[1])
    set consumed 1
    if _ff_is_time $argv[2]
        set end_mark (_ff_norm_time $argv[2])
        set consumed 2
        string match -q '*:*' -- $argv[2]; and set to_flag 1
    end
    return 0
end
