.PHONY: vundle
vundle: ~/.vimrc
	vim +PluginInstall +qall

.PHONY: command-t
command-t: ~/.vim/bundle/command-t/ruby/command-t/ext/command-t
	cd $<; \
	  make clean; \
	  $$(brew --prefix ruby@2.7)/bin/ruby extconf.rb; \
	  make
