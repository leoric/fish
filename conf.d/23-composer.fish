# PHP / Symfony shortcuts (was: composer.bash).
status is-interactive; or return

abbr -a co 'sudo -g www-data composer'
abbr -a ci 'sudo -g www-data composer install'
abbr -a cr 'sudo -g www-data composer require'
abbr -a ca 'composer dumpautoload'
abbr -a u bin/phpunit
abbr -a c bin/console
abbr -a bcm 'bin/console d:m:m'
abbr -a bcd 'bin/console d:m:diff'
abbr -a bcc 'bin/console rabbit:cons'
