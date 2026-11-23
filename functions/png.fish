function png --description 'Convert .webp to .png with dwebp'
    if not set -q argv[1]
        echo "Usage: png <file.webp>" >&2
        return 1
    end
    dwebp $argv[1] -o (basename -- $argv[1] .webp).png
end
