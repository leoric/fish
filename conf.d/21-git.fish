# Git shortcuts (was: git.bash). Short ones are abbreviations; the ones that need
# pipes, substitutions or special quoting are functions in functions/
# (gbda gk gke gg ggc glp gunwip gwip grt).
# Duplicates in the original are resolved to what the shell actually used
# (`gf` was defined three times; the last definition won).
status is-interactive; or return

abbr -a g git

abbr -a ga 'git add'
abbr -a gaa 'git add --all'
abbr -a gall 'git add --all'
abbr -a gapa 'git add --patch'

abbr -a gb 'git branch'
abbr -a gba 'git branch -a'
abbr -a gbl 'git blame -b -w'
abbr -a gbnm 'git branch --no-merged'
abbr -a gbr 'git branch --remote'
abbr -a gbs 'git bisect'
abbr -a gbsb 'git bisect bad'
abbr -a gbsg 'git bisect good'
abbr -a gbsr 'git bisect reset'
abbr -a gbss 'git bisect start'

abbr -a gm 'git commit -m'
abbr -a gma 'git commit -a -m'
abbr -a gc 'git commit -v'
abbr -a 'gc!' 'git commit -v --amend'
abbr -a 'gcn!' 'git commit -v --no-edit --amend'
abbr -a gcs 'git commit -S'
abbr -a gca 'git commit -v -a'
abbr -a 'gca!' 'git commit -v -a --amend'
abbr -a 'gcan!' 'git commit -v -a --no-edit --amend'
abbr -a 'gcans!' 'git commit -v -a -s --no-edit --amend'
abbr -a gco 'git checkout'
abbr -a gsw 'git switch'
abbr -a gsc 'git switch -c'
abbr -a gsm 'git switch main'
abbr -a gcf 'git config --list'
abbr -a gcl 'git clone --recursive'
abbr -a gclean 'git clean -fd'
abbr -a gpristine 'git reset --hard && git clean -dfx'

abbr -a gcount 'git shortlog -sn'
abbr -a gcp 'git cherry-pick'

abbr -a gd 'git diff HEAD'                       # staged + unstaged
abbr -a gdf 'git diff HEAD --name-status'        # status of every file only
abbr -a gdw 'git diff HEAD --word-diff'

abbr -a gfa 'git fetch --all --prune --tags'
abbr -a gf 'git fetch --all --prune --verbose'
abbr -a gftv 'git fetch --all --prune --tags --verbose'
abbr -a gfo 'git fetch origin'

abbr -a gignore 'git update-index --assume-unchanged'
abbr -a gignored 'git ls-files -v | grep "^[[:lower:]]"'
abbr -a git-svn-dcommit-push 'git svn dcommit && git push github main:svntrunk'

abbr -a gl 'git log'
abbr -a gls 'git log --stat -p'
abbr -a glg 'git log --graph'
abbr -a gll 'git log --graph --decorate --all'
abbr -a glm 'git log --graph --max-count=10'
abbr -a glo 'git log --oneline --decorate'
abbr -a ggoc 'git log --oneline --decorate --graph'
abbr -a ggo 'git log --oneline --decorate --graph --all'

abbr -a gme 'git merge'
abbr -a gmeom 'git merge origin/main'
abbr -a gmt 'git mergetool --no-prompt'
abbr -a gmtvim 'git mergetool --no-prompt --tool=vimdiff'
abbr -a gmum 'git merge upstream/main'

abbr -a gu 'git pull'
abbr -a guum 'git pull upstream main'
abbr -a gup 'git pull --rebase'
abbr -a gupv 'git pull --rebase -v'

abbr -a gp 'git push'
abbr -a gpd 'git push --dry-run'
abbr -a gpoat 'git push origin --all && git push origin --tags'
abbr -a gpu 'git push upstream'
abbr -a gpv 'git push -v'
abbr -a gpf 'git push --force'                   # prefer --force-with-lease

abbr -a gt 'git tag'
abbr -a gtd 'git tag -d'
abbr -a gtp 'git push --tags'

abbr -a gr 'git remote'
abbr -a gra 'git remote add'
abbr -a grb 'git rebase'
abbr -a grba 'git rebase --abort'
abbr -a grbc 'git rebase --continue'
abbr -a grbi 'git rebase -i'
abbr -a grbm 'git rebase main'
abbr -a grbs 'git rebase --skip'
abbr -a grh 'git reset HEAD'
abbr -a grhh 'git reset HEAD --hard'
abbr -a gru 'git reset --'
abbr -a gr1 'git reset --soft HEAD^'
abbr -a grmv 'git remote rename'
abbr -a grrm 'git remote remove'
abbr -a grset 'git remote set-url'
abbr -a grup 'git remote update'
abbr -a grv 'git remote -v'

abbr -a gs 'git status'
abbr -a gss 'git status -s'

abbr -a gsh 'git show'
abbr -a gsps 'git show --pretty=short --show-signature'

abbr -a gsd 'git svn dcommit'
abbr -a gsr 'git svn rebase'

abbr -a gsi 'git submodule init'
abbr -a gsu 'git submodule update'

abbr -a gst 'git stash save'
abbr -a gsta 'git stash apply'
abbr -a gstd 'git stash drop'
abbr -a gstl 'git stash list'
abbr -a gstp 'git stash pop'
abbr -a gsts 'git stash show --text'

abbr -a gts 'git tag -s'
abbr -a gtv 'git tag | sort -V'

abbr -a gunignore 'git update-index --no-assume-unchanged'
