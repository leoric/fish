function fcrop --description 'Detect crop rectangle of a video'
    if not set -q argv[1]
        echo "Usage: fcrop <video_file>"
        return 1
    end
    ffmpeg -i $argv[1] -vf cropdetect=24:16:0 -f null -
end
