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
  PS1="${debian_chroot:+($debian_chroot)}\[\e[31m\]\[\e[38;5;245m\]\u\[\e[00m\]@\[\e[38;5;172m\]\h\[\e[00m\]:\[\e[00;36m\]\w\[\e[00m\] "
  
  # If exit code of last command is non-zero, prepend this code to the prompt
  [[ "$ex" -ne 0 ]] && PS1="$ex $PS1"
  # Set colour of prompt
  PS1="\[$color\]$PS1"
  
  
}
