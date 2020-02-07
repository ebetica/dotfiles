#!/bin/bash

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
cp -f ~/.vimrc ~/.vimrc.backup
cp -f ~/.zshrc ~/.zshrc.backup
cp -f ~/.tmux.conf ~/.tmux.conf.backup
cp -f ~/.gitconfig ~/.gitconfig.backup
cp -f ~/.gitignore ~/.gitignore.backup
cp -f ~/.i3/config ~/.i3/config.backup

mkdir -p ~/.config/kak
cp -f ~/.config/kak/kakrc ~/.config/kak/kakrc.backup
# plug.kak
mkdir -p ~/.config/kak/plugins/
git clone https://github.com/andreyorst/plug.kak.git ~/.config/kak/plugins/plug.kak

ln -sf ~/dotfiles/.vimrc ~/
ln -sf ~/dotfiles/.tmux.conf ~/
ln -sf ~/dotfiles/gitignore ~/.gitignore
ln -sf ~/dotfiles/kakrc ~/.config/kak/kakrc
ln -sf ~/dotfiles/i3config ~/.i3/config

echo "source /etc/profile" >> ~/.zshrc
echo "source ~/dotfiles/.zshrc" >> ~/.zshrc

echo "[include]" >> ~/.gitconfig
echo " 	path = ~/dotfiles/gitconfig" >> ~/.gitconfig

echo "#include \"$(readlink -f ./Xresources)\"" >> ~/.Xresources

vim +PluginInstall +qall

exit 0
