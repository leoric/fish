function subl --description 'Open Sublime Text'
    set -l mac "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"
    if test -x $mac
        $mac $argv
    else if command -q subl
        command subl $argv
    else
        echo "subl: Sublime Text not found" >&2
        return 127
    end
end
