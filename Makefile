.PHONY: vundle

vundle: ~/.vimrc
	vim +PluginInstall +qall
