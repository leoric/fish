function wpr --description 'wp, then remove the original'
    wp $argv[1]; and rm $argv[1]
end
