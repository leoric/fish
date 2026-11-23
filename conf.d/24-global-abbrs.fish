# zsh "global aliases" (alias -g) -> abbreviations that expand anywhere on the line.
# Like the originals, a bare `L`, `G`, `N` ... as a whole word will expand.
status is-interactive; or return

abbr -a --position anywhere F -- --filter
abbr -a --position anywhere T -- '| tail'
abbr -a --position anywhere C -- '| ccze'
abbr -a --position anywhere M -- '| more'
abbr -a --position anywhere L -- '| less'
abbr -a --position anywhere H -- '| head'
abbr -a --position anywhere N -- '2>/dev/null'
abbr -a --position anywhere G -- '| grep'
abbr -a --position anywhere GI -- '| grep -i'
abbr -a --position anywhere GN -- '| grep -n'
abbr -a --position anywhere S -- '| sort'
abbr -a --position anywhere SU -- '| sort -u'

abbr -a --position anywhere KU -- '| iconv -c -f koi8r -t utf8'
abbr -a --position anywhere CU -- '| iconv -c -f cp1251 -t utf8'
abbr -a --position anywhere UK -- '| iconv -c -f utf8 -t koi8r'
abbr -a --position anywhere UC -- '| iconv -c -f utf8 -t cp1251'
