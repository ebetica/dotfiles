#!/bin/bash

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
cp -f ~/.vimrc ~/.vimrc.backup
cp -f ~/.zshrc ~/.zshrc.backup
cp -f ~/.tmux.conf ~/.tmux.conf.backup
cp -f ~/.gitconfig ~/.gitconfig.backup
cp -f ~/.gitignore ~/.gitignore.backup

mkdir -p ~/.oh-my-zsh/custom/themes
mkdir -p ~/.oh-my-zsh/custom/plugins
(cd ~/.oh-my-zsh/custom/plugins && git clone https://github.com/zsh-users/zsh-syntax-highlighting)

ln -s ~/dotfiles/.vimrc ~/
ln -s ~/dotfiles/.tmux.conf ~/
ln -s ~/dotfiles/gitignore ~/.gitignore

ln -s ~/dotfiles/ebetica.zsh-theme ~/.oh-my-zsh/custom/themes/
echo "source /etc/profile" >> ~/.zshrc
echo "source ~/dotfiles/.zshrc" >> ~/.zshrc

echo "[include]" >> ~/.gitconfig
echo " 	path = ~/dotfiles/gitconfig" >> ~/.gitconfig

echo "#include \"$(readlink -f ./xresources/Xresources)\"" >> ~/.Xresources

vim +PluginInstall +qall

exit 0
