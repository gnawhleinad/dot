.PHONY: vundle
vundle: ~/.vimrc
	vim +PluginInstall +qall

.PHONY: command-t
command-t: ~/.vim/bundle/command-t/ruby/command-t/ext/command-t
	cd $<; \
	  echo "2.7.1" >.ruby-version; \
	  ruby extconf.rb; \
	  make
