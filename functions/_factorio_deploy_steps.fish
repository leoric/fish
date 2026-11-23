# Overridable locations:
#   FACTORIO_MODS_DIR   Factorio mods folder
#   FACTORIO_STORE_DIR  where the zip is kept (default ~/MEGA/games/factorio)
#   FACTORIO_LAUNCH_CMD command to start the game (default: macOS `open` on Factorio.app)
function _factorio_deploy_steps
    set -l tmp_dir $argv[1]

    if not test -f info.json
        echo "❌ Error: info.json not found in the current directory!"
        return 1
    end

    echo "Parsing info.json..."
    set -l mod_name
    set -l mod_version_raw
    if type -q jq
        set mod_name (jq -r '.name // empty' info.json)
        set mod_version_raw (jq -r '.version // empty' info.json)
    else
        set mod_name (awk -F'"' '/"name"/{print $4; exit}' info.json)
        set mod_version_raw (awk -F'"' '/"version"/{print $4; exit}' info.json)
    end

    if test -z "$mod_name"; or test -z "$mod_version_raw"
        echo "❌ Error: Failed to parse 'name' or 'version' from info.json"
        return 1
    end

    set -l mod_version {$mod_name}_$mod_version_raw
    set -l zip_name $mod_version.zip

    set -l store_dir $HOME/MEGA/games/factorio
    set -q FACTORIO_STORE_DIR; and set store_dir $FACTORIO_STORE_DIR

    set -l mods_dir "$HOME/.factorio/mods"
    test (uname) = Darwin; and set mods_dir "$HOME/Library/Application Support/factorio/mods"
    set -q FACTORIO_MODS_DIR; and set mods_dir $FACTORIO_MODS_DIR

    set -l target_link "$mods_dir/$zip_name"

    echo "Starting deployment for mod: $mod_name (Version: $mod_version_raw)..."

    # Clear an existing symlink/file in the mods directory
    if test -L $target_link
        unlink $target_link
    else if test -e $target_link
        read -n 1 -l -P \n"⚠️ Warning: '$target_link' already exists and is NOT a symlink. Overwrite? (y/N): " reply
        echo ""
        if string match -qr '^[Yy]$' -- $reply
            rm -rf $target_link
        else
            echo "❌ Deployment aborted by user. Exiting."
            return 1
        end
    end

    # Isolated build in /tmp
    echo "Creating isolated archive building structure..."
    mkdir -p $tmp_dir/$mod_version
    rsync -a --exclude='.git*' --exclude='.DS_Store' --exclude='__MACOSX' ./ $tmp_dir/$mod_version/
    or return 1

    cd $tmp_dir
    and zip -r $zip_name $mod_version -x "*.DS_Store" -x "__MACOSX*" -x "*/images/*"
    and mv $zip_name $store_dir/
    and cd $mods_dir
    and ln -s $store_dir/$zip_name $zip_name
    or return 1

    if set -q FACTORIO_LAUNCH_CMD
        eval $FACTORIO_LAUNCH_CMD
    else if test (uname) = Darwin
        open /Applications/Games/Factorio.app
    end
    and echo "✅ Deployment complete! Symlink created in mods folder."
end
