function wp --description 'Convert an image to .webp (clipboard text names "image (N)" files)'
    if not set -q argv[1]
        echo "Usage: wp <file>" >&2
        return 1
    end
    set -l out (_av_name $argv[1])
    cwebp -q 85 -alpha_q 100 -m 6 $argv[1] -o $out.webp
end
