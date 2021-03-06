[ -r /Users/koowolab/.profile_lda ] && . /Users/koowolab/.profile_lda

HOMEBREW_PREFIX=$(brew --prefix)
if type brew &>/dev/null; then
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "$COMPLETION" ]] && source "$COMPLETION"
    done
  fi
fi

#  try the brew --prefix location for bash completion
[ -f "$(brew --prefix)/etc/bash_completion.d/git-completion.bash" ] && \
    . $(brew --prefix)/etc/bash_completion.d/git-completion.bash

GIT_PS1_SHOWUPSTREAM="verbose name"
GIT_PS1_SHOWCOLORHINTS=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWDIRTYSTATE=true

[ -f "$(brew --prefix)/etc/bash_completion.d/git-prompt.sh" ] && \
    . $(brew --prefix)/etc/bash_completion.d/git-prompt.sh

PS1='\[\033]0;$MSYSTEM:${PWD//[^[:ascii:]]/?}\007\]' # set window title
PS1="$PS1"'\[\033[32m\]'       # change to green
PS1="$PS1"'\u@\h '             # user@host<space>
PS1="$PS1"'\[\033[33m\]'       # change to brownish yellow
PS1="$PS1"'\w'                 # current working directory
PS1="$PS1"'\[\033[36m\]'  # change color to cyan
PS1="$PS1"'$(__git_ps1 " (%s)")'   # bash function
PS1="$PS1"'\[\033[0m\]'        # change color
PS1="$PS1"'\n'                 # new line
PS1="$PS1"'λ '                 # prompt: always λ

function pull_upstream {
  local current_branch=$(git rev-parse --abbrev-ref HEAD)
  local upstream_branch=$(git rev-parse --abbrev-ref --symbolic-full-name @{u})

  git checkout $upstream_branch
  git remote prune origin
  git pullr
  git checkout $current_branch
  git pullr
}

function prep_diff {
  gazelle
  clear
  setup-gopath //$1...
  clear
  bazel build //$1...
  clear
  bazel test //$1...
  clear
  arc lint > ~/notes/arclint-output
  clear
  coverage $1
}

alias ls='ls -AG'
alias ll='ls -AlG'
alias cdw='cd ~/go-code/src/code.uber.internal'
alias gcl='git clean -df && git checkout -- .'
alias gcom='git checkout origin/master --'
alias goLand='open -a GoLand'
alias intelliJ='open -a "IntelliJ IDEA"'
alias webStorm='open -a WebStorm'
alias pyCharm='open -a PyCharm'
alias cgp='GOPATH=$HOME/gocode'

export -f pull_upstream
export -f prep_diff


export CXXFLAGS="-mmacosx-version-min=10.9"
export CFLAGS="-mmacosx-version-min=10.9"
#export LDFLAGS="-mmacosx-version-min=10.9"

export LDFLAGS="-L/usr/local/opt/openblas/lib"
export CPPFLAGS="-I/usr/local/opt/openblas/include"
export PKG_CONFIG_PATH="/usr/local/opt/openblas/lib/pkgconfig"

#export GOPATH=$HOME/gocode
export GOPATH=$HOME/go-code

export PATH=$PATH:$GOPATH/bin

#eval "$(goenv init -)"
eval "$(direnv hook bash)"

complete -C /Users/koowolab/go-code/bin/gocomplete go
