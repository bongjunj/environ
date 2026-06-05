mkdir -p ~/.config/fish
mkdir -p ~/.config/helix
mkdir -p ~/.config/zellij

if [ -e ~/.config/nvim ] && [ ! -L ~/.config/nvim ]; then
  rm -rf ~/.config/nvim
fi

ln -sf "$(pwd)/config.fish" ~/.config/fish/config.fish
ln -sf "$(pwd)/helix/config.toml" ~/.config/helix/config.toml
ln -sf "$(pwd)/helix/languages.toml" ~/.config/helix/languages.toml
ln -sf "$(pwd)/zellij/config.kdl" ~/.config/zellij/config.kdl
ln -sf "$(pwd)/.tmux.conf" ~/.tmux.conf
ln -sf "$(pwd)/.gitconfig" ~/.gitconfig
ln -sfn "$(pwd)/nvim" ~/.config/nvim
