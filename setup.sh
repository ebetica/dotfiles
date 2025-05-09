#!/bin/bash

git submodule update --init --recursive
[ -e ~/.fzf ] || (git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | grep -v 'exec zsh')"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
cp -f ~/.vimrc ~/.vimrc.backup
cp -f ~/.zshrc ~/.zshrc.backup
cp -f ~/.tmux.conf ~/.tmux.conf.backup
cp -f ~/.gitconfig ~/.gitconfig.backup
cp -f ~/.gitignore ~/.gitignore.backup
cp -f ~/.i3/config ~/.i3/config.backup

mkdir -p ~/.config/kak
mkdir -p ~/.config/kak-lsp
mkdir -p ~/.config/.i3
cp -f ~/.config/kak/kakrc ~/.config/kak/kakrc.backup
cp -f ~/.config/kak-lsp/kak-lsp.toml ~/.config/kak-lsp/kak-lsp.toml.backup
# plug.kak
mkdir -p ~/.config/kak/plugins/
[ -d ~/.config/kak/plugins/plug.kak ] || git clone https://github.com/andreyorst/plug.kak.git ~/.config/kak/plugins/plug.kak
# cargo...
curl https://sh.rustup.rs -sSf | sh

ln -sf ~/dotfiles/.vimrc ~/
ln -sf ~/dotfiles/.tmux.conf ~/
ln -sf ~/dotfiles/gitignore ~/.gitignore
ln -sf ~/dotfiles/kakrc ~/.config/kak/kakrc
ln -sf ~/dotfiles/kak-lsp.toml ~/.config/kak-lsp/kak-lsp.toml
ln -sf ~/dotfiles/i3config ~/.config/.i3/config

echo "source /etc/profile" >> ~/.zshrc
echo "source ~/dotfiles/.zshrc" >> ~/.zshrc

echo "[include]" >> ~/.gitconfig
echo " 	path = ~/dotfiles/gitconfig" >> ~/.gitconfig

echo "#include \"$(readlink -f ./Xresources)\"" >> ~/.Xresources

vim +PluginInstall +qall

exit 0
