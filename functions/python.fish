function python --wraps python --description 'Use the global venv python when no venv is active'
    if test -z "$VIRTUAL_ENV"; and test -d "$PRO_VENV"
        $PRO_VENV/bin/python $argv
    else
        command python $argv
    end
end
