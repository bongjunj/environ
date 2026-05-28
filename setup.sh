mkdir -p ~/.config/fish
mkdir -p ~/.config/helix
if [ -e ~/.config/nvim ] && [ ! -L ~/.config/nvim ]; then
  rm -rf ~/.config/nvim
fi

ln -sf "$(pwd)/config.fish" ~/.config/fish/config.fish
ln -sf "$(pwd)/helix/config.toml" ~/.config/helix/config.toml
ln -sf "$(pwd)/.tmux.conf" ~/.tmux.conf
ln -sf "$(pwd)/.gitconfig" ~/.gitconfig
ln -sfn "$(pwd)/nvim" ~/.config/nvim
