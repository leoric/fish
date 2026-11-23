# Interactive setup (was: .zshrc). Environment and PATH live in conf.d/00-env.fish,
# aliases/abbreviations in conf.d/2*.fish, helper functions in functions/.

if status is-interactive
    set -g fish_greeting          # no "Welcome to fish" banner

    # zoxide (jump)
    type -q zoxide; and zoxide init fish | source

    # keychain: start/attach the ssh agent, load the key, import the env.
    # Change id_rsa to your key (e.g. id_ed25519).
    if type -q keychain
        keychain --quiet --agents ssh id_rsa
        set -l kc ~/.keychain/(uname -n)-fish
        test -f $kc; and source $kc
    end

    # fzf: Ctrl-R history, Ctrl-T files, Alt-C directories (fzf >= 0.48)
    if type -q fzf
        fzf --fish 2>/dev/null | source
        type -q ag; and set -gx FZF_DEFAULT_COMMAND 'ag -l -g ""'
        set -gx FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border"
    end

    # Key bindings (was the xterm-only bindkey block; fish already has Up/Down
    # history search, working Delete and Ctrl-U). Alt-s prepends sudo (replaces zsh-sudo).
    bind \ea beginning-of-line
    bind \e\cb beginning-of-line
    bind \e\[1\;5D beginning-of-line
    bind \ee end-of-line                  # shadows Alt-e (edit_command_buffer); Alt-v still does that
    bind \e\cf end-of-line
    bind \e\[1\;6D end-of-line

    # iTerm2 shell integration (macOS), if installed
    test -e $HOME/.iterm2_shell_integration.fish; and source $HOME/.iterm2_shell_integration.fish

    # Optional: local overrides and secrets, never committed
    test -f $HOME/.config/fish/local.fish; and source $HOME/.config/fish/local.fish

    # Starship: time in transient prompt
    function starship_transient_prompt_func
        set_color 888888; date +%T | string collect | string trim | tr '\n' ' '; set_color normal
        starship module character
    end

    if status is-interactive
        switch $TERM_PROGRAM
            case zed # running inside IDE
                if test -f ~/.config/starship-ide.toml
                    set -gx STARSHIP_CONFIG ~/.config/starship-ide.toml
                else
                    set -gx STARSHIP_CONFIG ~/.config/starship.toml
                end
            case '*' # running normally
                set -gx STARSHIP_CONFIG ~/.config/starship.toml
        end

        starship init fish | source
        enable_transience
    end
end
