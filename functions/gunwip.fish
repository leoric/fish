function gunwip --description 'Undo the last commit if it is a --wip-- commit'
    git log -n 1 | grep -q -e '--wip--'; and git reset HEAD~1
end
