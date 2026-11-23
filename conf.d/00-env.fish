# Environment (was: zprofile). conf.d runs for every fish, interactive or not.

# Homebrew: Apple Silicon, Intel macOS, Linuxbrew
for b in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew
    if test -x $b
        $b shellenv fish | source
        break
    end
end
set -gx HOMEBREW_NO_ANALYTICS 1
set -gx HOMEBREW_NO_ENV_HINTS 1

set -gx LANG en_US.UTF-8
set -gx CLICOLOR 1
set -gx COLORTERM truecolor
set -gx BLOCK_SIZE human-readable

# Pager
set -gx LESS -RFX
set -gx LESSHISTFILE -
set -gx MANPAGER 'less -R --use-color -Dd+r -Du+b'
set -gx PAGER less

# Project virtualenv switching (see conf.d/30-python.fish)
set -gx PRO_PROJECT_ROOT $HOME/pro
set -gx PYTHON_DEFAULT_VENV $HOME/.venv
# Stop activate.fish of python venv from rewriting the prompt
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

# PATH. fish_add_path skips directories that don't exist and never duplicates,
# so machine-specific entries are harmless elsewhere.
fish_add_path --global --move \
    $HOME/.local/bin \
    $PYTHON_DEFAULT_VENV/bin \
    $HOME/.spoofdpi/bin \
    $HOME/MEGA/IT/bin

# Colours: prefer an eza theme, otherwise vivid
if test -s $HOME/.config/eza/theme.yml
    set -e LS_COLORS
    set -e EZA_COLORS
    set -e EXA_COLORS
else if type -q vivid
    set -gx LS_COLORS (vivid generate gruvbox-dark)
end

umask 002
