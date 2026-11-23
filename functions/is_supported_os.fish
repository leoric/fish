function is_supported_os --description 'true on macOS and on Linux that is not WSL'
    switch (uname)
        case Darwin
            return 0
        case Linux
            not grep -qi microsoft /proc/version 2>/dev/null
        case '*'
            return 1
    end
end
