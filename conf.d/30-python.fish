# Automatic project virtualenv (was: python.zsh `manage_pro_venv` + chpwd hook).
#  - Outside $PRO_PROJECT_ROOT, or inside it with no .py files below: deactivate.
#  - Inside it with a .py file: activate $PWD/.venv if present, else $PYTHON_DEFAULT_VENV.
status is-interactive; or return

function manage_pro_venv --on-variable PWD --description 'Switch project venv on cd'
    set -l inside 0
    if test "$PWD" = "$PRO_PROJECT_ROOT"; or string match -q -- "$PRO_PROJECT_ROOT/*" $PWD
        set inside 1
    end

    set -l has_py 0
    if test $inside -eq 1
        if command find $PWD \( -name '.*' -o -name __pycache__ -o -name node_modules \
                -o -name .venv -o -name venv \) -prune \
                -o -type f -name '*.py' -print -quit 2>/dev/null | grep -q .
            set has_py 1
        end
    end

    if test $has_py -eq 0
        if set -q VIRTUAL_ENV; and functions -q deactivate
            deactivate
        end
        return
    end

    set -l target $PYTHON_DEFAULT_VENV
    test -d $PWD/.venv; and set target $PWD/.venv

    test -f $target/bin/activate.fish; or return
    if test "$VIRTUAL_ENV" != "$target"
        functions -q deactivate; and deactivate
        source $target/bin/activate.fish
    end
end

manage_pro_venv
