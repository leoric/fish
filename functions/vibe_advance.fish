function vibe_advance --description 'Commit staged CHANGELOG.txt diff as a version bump and tag it'
    set -l version_type minor
    set -l manual_version ''
    set -l new_version ''

    # 1. Argument processing
    if test -n "$argv[1]"; and string match -q -- '*.*' $argv[1]
        set manual_version $argv[1]
    else
        while set -q argv[1]
            switch $argv[1]
                case -v --version
                    if set -q argv[2]; and test -n "$argv[2]"; and not string match -q -- '-*' $argv[2]
                        set manual_version $argv[2]
                        set -e argv[1..2]
                    else
                        echo "Error: Flag $argv[1] requires a version argument (e.g., 1.2.3)"
                        return 1
                    end
                case 1 major
                    set version_type major
                    set -e argv[1]
                case 2 minor
                    set version_type minor
                    set -e argv[1]
                case 3 patch
                    set version_type patch
                    set -e argv[1]
                case '*'
                    echo "Error: Unknown argument '$argv[1]'"
                    echo "Usage: vibe_advance [major|minor|patch | 1|2|3] [X.X.X]"
                    return 1
            end
        end
    end

    # 2. Manual version: validate, pad to X.Y.Z, make sure it is unused
    if test -n "$manual_version"
        if not string match -qr '^[0-9]+(\.[0-9]+){0,2}$' -- $manual_version
            echo "Error: Version '$manual_version' must contain only digits separated by dots (e.g., 1, 1.4, or 1.4.0)"
            return 1
        end

        set -l mp (string split . -- $manual_version)
        set -l m_major $mp[1]
        set -l m_minor 0
        set -l m_patch 0
        set -q mp[2]; and set m_minor $mp[2]
        set -q mp[3]; and set m_patch $mp[3]
        set manual_version $m_major.$m_minor.$m_patch

        if git show-ref --verify --quiet "refs/tags/v$manual_version"
            or git show-ref --verify --quiet "refs/tags/$manual_version"
            or git log --all --format='%s' | grep -Fxq -- "$manual_version"
            echo "Error: Version $manual_version already exists in Git history (as a tag or commit subject)!"
            return 1
        end

        set new_version $manual_version
    end

    # 3. Stage everything
    git add -A

    # 4. Commit message = lines added to CHANGELOG.txt (header lines filtered out)
    set -l commit_msg (git diff --staged -- CHANGELOG.txt | sed -n '/^+++/d; /^+/s/^+//p' | string collect)
    if test -z "$commit_msg"
        echo "Error: No new changes found in CHANGELOG.txt to generate a commit message."
        return 1
    end

    # 5. Auto-increment from the newest v* tag
    if test -z "$manual_version"
        set -l latest_tag (git tag --list 'v*' --sort=-v:refname 2>/dev/null | head -n 1)
        test -z "$latest_tag"; and set latest_tag v0.0.0
        set -l current_version (string replace -r '^v' '' -- $latest_tag)

        set -l parts (string split . -- $current_version)
        set -l major 0
        set -l minor 0
        set -l patch 0
        set -q parts[1]; and set major $parts[1]
        set -q parts[2]; and set minor $parts[2]
        set -q parts[3]; and set patch $parts[3]

        switch $version_type
            case major
                set major (math $major + 1)
                set minor 0
                set patch 0
            case minor
                set minor (math $minor + 1)
                set patch 0
            case patch
                set patch (math $patch + 1)
        end

        set new_version $major.$minor.$patch
        echo "Auto-incrementing version: $current_version -> $new_version"
    else
        echo "Using manual version: $new_version"
    end

    # 6. Commit and tag
    echo "Commit message:"
    echo $commit_msg
    echo "---"

    if not git commit -m "$new_version" -m "$commit_msg"
        echo "Error: Git commit failed."
        return 1
    end

    if not git tag -a "v$new_version" -m "Release $new_version"
        echo "Error: Tagging failed. Rollback commit..."
        git reset --soft HEAD~1
        return 1
    end

    echo "Successfully committed and tagged as v$new_version"
end
