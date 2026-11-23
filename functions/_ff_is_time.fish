function _ff_is_time
    string match -qr '^[0-9:.]+$' -- "$argv[1]"; and not contains -- "$argv[1]" 264 720
end
