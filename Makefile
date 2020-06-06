.PHONY: vundle
vundle: ~/.vimrc
	vim +PluginInstall +qall

.PHONY: command-t
command-t: ~/.vim/bundle/command-t/ruby/command-t/ext/command-t
	cd $<; \
	  make clean; \
	  $$(brew --prefix ruby@2.7)/bin/ruby extconf.rb; \
	  make

.PHONY: vim-go
vim-go: ~/.vim/bundle/vim-go
	cd $<; \
	  git fetch origin v1.23; \
	  git checkout FETCH_HEAD

.PHONY: .bash_profile
.bash_profile:
	if [[ "${OSTYPE}" == "darwin" ]]; then \
		rm -f ${HOME}/$@ ; \
		ln -s $(realpath osx/$@) ${HOME}/$@ ; \
	fi

.PHONY: .bashrc
.bashrc:
	if [[ -f /etc/arch-release ]]; then \
		rm -f ${HOME}/$@ ; \
		ln -s $(realpath arch/$@) ${HOME}/$@ ; \
	fi
