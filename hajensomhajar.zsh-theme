local user='%{$fg[green]%}%n@%{$fg[green]%}%m%{$reset_color%}'
local pwd='%{$fg[blue]%}%~%{$reset_color%}'
PROMPT="%B${user}%b ${pwd} %# "
