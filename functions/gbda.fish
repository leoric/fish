function gbda --description 'Delete local branches already merged (keeps main)'
    git branch --merged | command grep -vE '^(\*|\s*main\s*$)' | command xargs -n 1 git branch -d
end
