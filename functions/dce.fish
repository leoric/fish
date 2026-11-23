function dce --description 'dc exec shortcuts (php, co, ci, cr, ca, u, c, cd, cc, bcm, bcd, bcc)'
    if not set -q argv[1]
        dc exec
        return
    end
    set -l sub $argv[1]
    set -e argv[1]
    set -l php dc exec -u www-data php

    switch $sub
        case php
            $php $argv
        case co
            $php php -d xdebug.mode=off /opt/composer.phar $argv
        case ci
            $php php -d xdebug.mode=off /opt/composer.phar install $argv
        case cr
            $php php -d xdebug.mode=off /opt/composer.phar require $argv
        case ca
            $php php -d xdebug.mode=off /opt/composer.phar dumpautoload $argv
        case u
            $php php -d xdebug.mode=off bin/phpunit $argv
        case c
            $php php -d xdebug.mode=off bin/console $argv
        case cd
            $php php bin/console $argv
        case cc
            $php php -d xdebug.mode=off bin/console ca:cl $argv
        case bcm dmm
            $php php -d xdebug.mode=off bin/console d:m:m -n --all-or-nothing $argv
        case bcd dmd
            $php php -d xdebug.mode=off bin/console d:m:diff $argv
        case bcc
            $php php bin/console rabbit:cons $argv
        case '*'
            dc exec $sub $argv
    end
end
