function python --wraps python3 --description 'Use the global venv python when no venv is active'
    if test -z "$VIRTUAL_ENV"; and test -d "$PYTHON_DEFAULT_VENV"
        $PYTHON_DEFAULT_VENV/bin/python3 $argv
    else
        command python3 $argv
    end
end
