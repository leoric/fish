# Docker shortcuts (was: docker.bash). `dc` and `dce` live in functions/.
status is-interactive; or return

abbr -a d docker
abbr -a dcu 'dc up'
abbr -a dcud 'dc up -d'
abbr -a dcd 'dc down'
abbr -a dcr 'dc down && dc up -d'
