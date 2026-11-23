function factorio_tag --description 'git tag vX.Y.Z from the nearest Factorio info.json'
    # Locate info.json under the current folder, preferring the shallowest.
    # (awk ranks by path depth; BSD/macOS find has no -printf)
    set -l info_path (command find . -name info.json -not -path '*/build/*' -not -path '*/.git/*' \
        | awk -F/ '{print NF, $0}' | sort -n | head -n1 | cut -d' ' -f2-)

    if test -z "$info_path"
        echo "❌ Error: info.json not found anywhere under "(pwd) >&2
        return 1
    end

    set -l mod_version (jq -r '.version' $info_path)
    if test -z "$mod_version"; or test "$mod_version" = null
        echo "❌ Error: Failed to parse 'version' from $info_path" >&2
        return 1
    end

    set -l tag_name v$mod_version
    git tag $tag_name; and echo "✅ Created tag $tag_name (from $info_path)"
end
