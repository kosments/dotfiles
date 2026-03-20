# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH=/opt/homebrew/bin:$PATH
export PATH="$VOLTA_HOME/bin:$PATH"
export PATH=/opt/homebrew/opt/python@3.10/libsec/bin:$PATH
export PATH=$HOME/.progate/bin:$PATH
export LANG=C
export PS1="%1~ %# "
export PATH="/opt/homebrew/bin/rbenv/bin:$PATH"
eval "$(rbenv init -)"
source "/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc"
source "/opt/homebrew/share/google-cloud-sdk/path.zsh.inc"
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8

# -----------------------------
# Terminal Log get
# -----------------------------
#unset STARTED
STARTED=yes
if [ -z "$STARTED" ]; then
  export STARTED=yes
  LOG_PATH_START="/Users/kosments/dev/terminal-log/`date "+%Y-%m-%d_%H%M%S"`.log"
  exec script $LOG_PATH_START
  trap 'ansifilter -i $LOG_PATH_START -o "/Users/kosments/dev/terminal-log/`date "+%Y-%m-%d_%H%M%S"`.log"; unset STARTED' EXIT
fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


export PATH=$HOME/.progate/bin:$PATH

# added by Servbay
export PATH=/Applications/ServBay/bin:/Applications/ServBay/sbin:/Applications/ServBay/script:$PATH

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Command completion
zinit ice wait'0'; zinit light zsh-users/zsh-completions
autoload -Uz compinit && compinit

# Make completion match lowercase to uppercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# When displaying a list of completion candidates, you can select them with Tab or arrows.
zstyle ':completion:*:default' menu select=1 

# Syntax highlighting
zinit light zsh-users/zsh-syntax-highlighting

# History completion
zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"

# history search (ctrl+R)
function peco-history-selection() {
  BUFFER=`history -n 1 | tac  | awk '!a[$0]++' | peco`
  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection

# change directory & search in the history (ctrl+E)
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
  autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':completion:*' recent-dirs-insert both
  zstyle ':chpwd:*' recent-dirs-default true
  zstyle ':chpwd:*' recent-dirs-max 1000
  zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi
function peco-cdr () {
  local selected_dir="$(cdr -l | sed 's/^[0-9]* *//' | peco)"
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
}
zle -N peco-cdr
bindkey '^E' peco-cdr

# change directory & search under the history (ctrl+X)
function find_cd() {
  local selected_dir=$(find . -type d | peco)
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
}
zle -N find_cd
bindkey '^X' find_cd

# change directory & search under the git root repository (ctrl+G)
function peco-src () {
  local selected_dir=$(ghq list -p | peco)
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
}
zle -N peco-src
bindkey '^G' peco-src

# History management
HISTFILE=$ZDOTDIR/.zsh-history
HISTSIZE=100000
SAVEHIST=1000000

# Share history with other zsh
setopt inc_append_history
setopt share_history

# cd even if path is entered directly
setopt AUTO_CD

# Completion of environment variables
setopt AUTO_PARAM_KEYS


export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Added by Windsurf
export PATH="/Users/kosments/.codeium/windsurf/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/kosments/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator
export JAVA_HOME=$(/usr/libexec/java_home -v 17)

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/kosments/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
eval "$(starship init zsh)"

# Added by Antigravity
export PATH="/Users/kosments/.antigravity/antigravity/bin:$PATH"

# Turso
export PATH="$PATH:/Users/kosments/.turso"
eval "$(goenv init -)"
eval "$(mise activate zsh)"
