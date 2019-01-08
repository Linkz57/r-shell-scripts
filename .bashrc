alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ll='ls --color=always -Flah'
alias date='date +%Y-%m-%d_%H-%M'
alias t='\date +%H:%M'
alias ssh='ssh -o VisualHostKey=yes'
alias count='wc -l'
alias password="strings -es < /dev/urandom | head | tr -cd '[[:alnum:]]._-' ; printf '\n'"
export SUDO_EDITOR=/usr/bin/kate



## thanks to Chris Marshall AKA codegoalie for this alert alias
## https://gist.github.com/codegoalie/975690/82d6198b65fdf00c84f93e01f7e6cdb2f22fe524
## Add an "alert" alias for long running commands.  Use like so:
##   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'




## Thanks to Daniel Weibel at https://gist.github.com/weibeld/f3b6e6187029924a9b3d
## for giving an exit code before my prompt, without having to run Byobu.

# Set a Bash prompt that includes the exit code of the last executed command.
#
# Setup: paste the content of this file to ~/.bashrc, or source this file from
# ~/.bashrc (make sure ~/.bashrc is sourced by ~/.bash_profile or ~/.profile)
#
# Daniel Weibel <danielmweibel@gmail.com> October 2015
#------------------------------------------------------------------------------#
export PROMPT_COMMAND=set_prompt

set_prompt() {
  # Capture exit code of last command
  local ex=$?

  #----------------------------------------------------------------------------#
  # Bash text colour specification:  \e[<STYLE>;<COLOUR>m
  # (Note: \e = \033 (oct) = \x1b (hex) = 27 (dec) = "Escape")
  # Styles:  0=normal, 1=bold, 2=dimmed, 4=underlined, 7=highlighted
  # Colours: 31=red, 32=green, 33=yellow, 34=blue, 35=purple, 36=cyan, 37=white
  #----------------------------------------------------------------------------#
  local color='\e[38;5;202m'
#  local reset='\e[0m'

  # Set prompt content
#  PS1="\u@\h:\w$\[$reset\] "
## I don't like green as much as Mr. Weibel, so I'm going to steal and modify Byobu's $PS1
  if hostname | grep laptop >/dev/null ; then
    ## random bit stolen from
    ## https://www.commandlinefu.com/commands/view/12548/generate-a-random-text-color-in-bash
	  PS1="${debian_chroot:+($debian_chroot)}\[\e[31m\]\[\e[38;5;245m\]\u\[\e[00m\]@\[\e[38;5;3$(( $RANDOM * 6 / 32767 + 1 ))m\]\h\[\e[00m\]:\[\e[00;36m\]\w\[\e[00m\] "
  else
	  PS1="${debian_chroot:+($debian_chroot)}\[\e[31m\]\[\e[38;5;245m\]\u\[\e[00m\]@\[\e[38;5;3m\]\h\[\e[00m\]:\[\e[00;36m\]\w\[\e[00m\] "
  fi
  # If exit code of last command is non-zero, prepend this code to the prompt
  [[ "$ex" -ne 0 ]] && PS1="$ex $PS1"
  # Set colour of prompt
  PS1="\[$color\]$PS1"
  
  
}
