# ~benc/.zshrc

# Usage: pskill <process name>
pskill () 
{
  local pid
  pid=$(ps -ax | grep $1 | grep -v grep | awk '{ print $1 }')
  echo -n "killing $1 (process $pid)...\n"
  kill -9 $=pid
}

# Put fun stuff in the title bar. But not if in the console
function precmd()
{
  if [[ $TERM == "xterm" ]]; then
    echo -n "\033]0;$USER @ $HOST -- $1\007"
  fi
}

watch=(notme)
WATCHFMT='%n %a %l from %m at %t.'

alias ssh='ssh -X -Y'
alias ll='ls -lha'
alias pst='pstree -lacp'
#alias m='mutt'
alias s='sudo '
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias rsh='ssh -x'
umask 0022

# hack between ls & gls
if [[ $(uname) == "AIX" || $(uname) == "FreeBSD" || $(uname) == "SunOS" ]]; then
  alias ls='gls --color'
else
  alias ls='ls --color=auto'
  # grep: warning: GREP_OPTIONS is deprecated; please use an alias or script
  alias grep='grep --color=auto'
fi

PATH=$PATH:/bin:/sbin
# Stop Ctrl+S and Ctrl+Q from being annoying
# @@ get it to work after an ssh crash
stty start ""
stty stop ""


export EDITOR=vim
export VISUAL=vim
export PAGER=less
export LESS=-sMR
export CLICOLOR_FORCE=yes
export COLORTERM=yes

# @@ compctl  -g "*(-/) .*(-/)" cd
#bindkey "^a" beginning-of-line
#bindkey "^e" end-of-line
bindkey -v

# indicate mode and time
function zle-line-init zle-keymap-select {
  RPROMPT="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --} [%D{%L:%M:%S %p}]"
  RPROMPT2=$RPS1
  TMOUT=1
  TRAPALRM() {
    zle reset-prompt
  }
}

zle -N zle-line-init
zle -N zle-keymap-select

eval `dircolors -b /etc/DIR_COLORS.lightbgcolor`
export LS_COLORS

export HISTSIZE=5000
export HISTFILE="$HOME/.zhistory"
export SAVEHIST=$HISTSIZE
setopt inc_append_history
setopt hist_fcntl_lock
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt share_history
setopt no_beep
setopt auto_cd
setopt correct
setopt auto_list
setopt complete_in_word
setopt auto_pushd
setopt complete_aliases
setopt extended_glob
setopt zle
unset autologout
unset MAILCHECK

autoload -U compinit && compinit
autoload zmv

zstyle ':completion:*' completer _complete _prefix
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'
zstyle ':completion::complete:*' '\'
zstyle ':completion::complete:*:tar:directories' file-patterns '*~.*(-/)'
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:history-words' stop verbose
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
#zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} 
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"


# dark background
#[ $UID != 0 ] && PROMPT=$'%{\e[0m%}[%{\e[1;32m%}%n%{\e[0m%}@%{\e[1;36m%}%m%{\e[0m%}:%{\e[1;33m%}%~%{\e[0m%}] %# '

# light background
[ $UID != 0 ] && PROMPT=$'%{\e[0m%}[%{\e[00;32m%}%n%{\e[0m%}@%{\e[00;36m%}%m%{\e[0m%}:%{\e[00;33m%}%~%{\e[0m%}] %# '

export LC_ALL=en_US.UTF-8

if [[ ${TERM} == "linux" ]]; then
  export LESS_TERMCAP_md=$'\e[01;38;5;74m'  # bold mode      - main      (cyan)
  export LESS_TERMCAP_us=$'\e[38;5;97m'     # underline mode - second    (purp)
  export LESS_TERMCAP_so=$'\e[38;5;196m'    # standout-mode  - info/find (red)
  export LESS_TERMCAP_mb=$'\e[01;31m'       # begin blinking - unused?   (red)
  export LESS_TERMCAP_ue=$'\e[0m'           # end underline
  export LESS_TERMCAP_se=$'\e[0m'           # end standout-mode
  export LESS_TERMCAP_me=$'\e[0m'           # end all mode        - txt rest
  else
  export LESS_TERMCAP_md=$'\e[01;34m'
  export LESS_TERMCAP_us=$'\e[01;35m'
  export LESS_TERMCAP_so=$'\e[01;30m'
  export LESS_TERMCAP_mb=$'\e[01;31m'
  export LESS_TERMCAP_ue=$'\e[0m'
  export LESS_TERMCAP_se=$'\e[0m'
  export LESS_TERMCAP_me=$'\e[0m'
fi
