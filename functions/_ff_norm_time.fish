function _ff_norm_time
    if string match -q '*:*' -- $argv[1]
        echo 00:$argv[1]
    else
        echo $argv[1]
    end
end
