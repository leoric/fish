function dc --description 'docker compose, picking ./docker-local/ compose file by OS'
    set -l file ./docker-local/docker-compose.yml
    switch (uname)
        case Linux
            set file ./docker-local/docker-compose.linux.yml
        case Darwin
            set file ./docker-local/docker-compose.macos.yml
    end

    # docker-compose v1 if present, otherwise the `docker compose` plugin
    set -l compose docker-compose
    type -q docker-compose; or set compose docker compose

    if not test -f ./docker-compose.yml; and test -f $file
        $compose -f $file $argv
    else
        $compose $argv
    end
end
