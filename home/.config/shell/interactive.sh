alias ll='ls -alF'
alias la='ls -A'
# Initialize NVM only when a Node tool is first requested.
if [ -s "$HOME/.nvm/nvm.sh" ]; then
    _dotfiles_load_nvm() {
        unset -f nvm node npm npx corepack
        export NVM_DIR="$HOME/.nvm"
        . "$NVM_DIR/nvm.sh"
    }
    nvm() { _dotfiles_load_nvm; nvm "$@"; }
    node() { _dotfiles_load_nvm; node "$@"; }
    npm() { _dotfiles_load_nvm; npm "$@"; }
    npx() { _dotfiles_load_nvm; npx "$@"; }
    corepack() { _dotfiles_load_nvm; corepack "$@"; }
fi
