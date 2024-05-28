# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)
source $ZSH/oh-my-zsh.sh

# User configuration
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Brew stuff
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Aliases
alias v='nvim'
eval "$(pyenv init -)"
eval "$(direnv hook zsh)"

# ---- Eza (better ls) -----
alias ls="eza --icons=always"

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"
alias cd="z"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH=$PATH:/Users/rustemhutiev/.spicetify
export PIPENV_VENV_IN_PROJECT=1

# set up fzf key 
eval "$(fzf --zsh)"

# Better search with fzf

# -- Use fd instead of fzf --
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# Git fzf
source ~/fzf-git.sh/fzf-git.sh

# thefuck alias
eval $(thefuck --alias)

# FZF catpuccin
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# poetry
export PATH="$HOME/.local/bin:$PATH"

# openssl
export PATH="$HOMEBREW_PREFIX/opt/openssl@1.1/bin:$PATH"
export DYLD_FALLBACK_LIBRARY_PATH="$HOMEBREW_PREFIX/opt/openssl@1.1/lib:$DYLD_FALLBACK_LIBRARY_PATH"

# curl
export PATH="$HOMEBREW_PREFIX/opt/curl/bin:$PATH"

# zstd
export LIBRARY_PATH="$HOMEBREW_PREFIX/opt/zstd/lib"


pkgs=(openssl@3 curl readline librdkafka zlib freetds mysql-client zstd)
for pkg in $pkgs; do
    pkg_dir="$HOMEBREW_PREFIX/opt/$pkg"
    
    lib_dir="$pkg_dir/lib"

    if [ -d "$lib_dir" ]; then
        export LDFLAGS="$LDFLAGS -L$lib_dir"
    fi
    
    include_dir="$pkg_dir/include"
    if [ -d "$include_dir" ]; then
        export CPPFLAGS="$CPPFLAGS -I$include_dir"
    fi
    
    pkg_config_dir="$lib_dir/pkgconfig"
    if [ -d "$pkg_config_dir" ]; then
        export PKG_CONFIG_PATH="${PKG_CONFIG_PATH+$PKG_CONFIG_PATH:}$pkg_config_dir"
    fi
done
