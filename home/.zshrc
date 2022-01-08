# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory nomatch notify
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/dobbs/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

BULLETTRAIN_PROMPT_ADD_NEWLINE=0 # plays better with iterm2 shell integration
BULLETTRAIN_CONTEXT_DEFAULT_USER=$USER
BULLETTRAIN_DIR_BG=152
BULLETTRAIN_DIR_FG=black
BULLETTRAIN_NVM_BG=151
BULLETTRAIN_NVM_FG=black
BULLETTRAIN_RUBY_BG=224
BULLETTRAIN_RUBY_FG=black
BULLETTRAIN_VIRTUALENV_BG=151 #144 #230
BULLETTRAIN_VIRTUALENV_FG=black
BULLETTRAIN_KCTX_BG=146
BULLETTRAIN_KCTX_FG=black
# BULLETTRAIN_GIT_BG=223
# BULLETTRAIN_GIT_FG=black

source "${HOME}/.zgen/zgen.zsh"
if ! zgen saved; then

  # specify plugins here
  zgen oh-my-zsh

  # If zsh-syntax-highlighting is bundled after zsh-history-substring-search,
  # they break, so get the order right.
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-history-substring-search

  # Set keystrokes for substring searching
  zmodload zsh/terminfo
  bindkey "$terminfo[kcuu1]" history-substring-search-up
  bindkey "$terminfo[kcud1]" history-substring-search-down

  # Warn you when you run a command that you've set an alias for
  zgen load djui/alias-tips

  # Adds aliases to open your current repo & branch on github.
  zgen load peterhurford/git-it-on.zsh

  zgen oh-my-zsh plugins/colored-man-pages
  zgen oh-my-zsh plugins/emacs
  zgen oh-my-zsh plugins/git
  zgen oh-my-zsh plugins/github
  zgen oh-my-zsh plugins/kubectl
  zgen oh-my-zsh plugins/nvm
  zgen oh-my-zsh plugins/rbenv
  zgen oh-my-zsh plugins/python
  zgen oh-my-zsh plugins/rsync
  zgen oh-my-zsh plugins/tmux

  if [ $(uname -a | grep -ci Darwin) = 1 ]; then
    # Load macOS-specific plugins
    zgen oh-my-zsh plugins/brew
    zgen oh-my-zsh plugins/macos
  fi

  zgen load chrissicool/zsh-256color

  # Load more completion files for zsh from the zsh-lovers github repo
  zgen load zsh-users/zsh-completions src

  # Add Fish-like autosuggestions to your ZSH
  zgen load zsh-users/zsh-autosuggestions

  # Bullet train prompt setup
  zgen load caiogondim/bullet-train-oh-my-zsh-theme bullet-train

  # generate the init script from plugins above
  zgen save
fi

typeset -U BULLETTRAIN_PROMPT_ORDER
BULLETTRAIN_PROMPT_ORDER+=(kctx)

# Thanks, unixorn:
# https://github.com/unixorn/zsh-quickstart-kit/blob/daf8be4b46/zsh/.zshrc#L225-L235
# Make it easy to append your own customizations that override the above by
# loading all files from the ~/.zshrc.d directory
mkdir -p ~/.zshrc.d
if [ -n "$(/bin/ls ~/.zshrc.d)" ]; then
  for dotfile in ~/.zshrc.d/*
  do
    if [ -r "${dotfile}" ]; then
      source "${dotfile}"
    fi
  done
fi
