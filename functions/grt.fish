function grt --description 'cd to the git repository root'
    cd (git rev-parse --show-toplevel 2>/dev/null; or echo .)
end
