# -> use264, use720, q, vf_stack, extra_args (in ff's scope)
function _ff_parse_flags --no-scope-shadowing
    set -l vf_flag 0
    while set -q argv[1]
        switch $argv[1]
            case 264
                set use264 1
                set vf_flag 0
            case 720
                set use720 1
                set vf_flag 0
                set -a vf_stack "scale=w='if(lt(iw,ih),min(720,iw),-2)':h='if(lt(iw,ih),-2,min(720,ih))'"
            case -q
                if not set -q argv[2]; or string match -q -- '-*' $argv[2]
                    echo "ff: -q requires a value" >&2
                    return 1
                end
                set q $argv[2]
                set -e argv[1]
                set vf_flag 0
            case -vf
                set vf_flag 1
            case '*'
                if test $vf_flag -eq 1; and not string match -qr '^-' -- $argv[1]
                    set -a vf_stack $argv[1]
                else
                    set vf_flag 0
                    set -a extra_args $argv[1]
                end
        end
        set -e argv[1]
    end
    return 0
end
