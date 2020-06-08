.PHONY: vundle
vundle: ~/.vimrc
	vim +PluginInstall +qall

.PHONY: youcompleteme
youcompleteme: ~/.vim/bundle/YouCompleteMe
	cd $<; \
	  python install.py \
	    --clangd-completer \
	    --ts-completer \
	    --rust-completer

.PHONY: command-t
command-t: ~/.vim/bundle/command-t/ruby/command-t/ext/command-t
	cd $<; \
	  make clean; \
	  if [[ "${OSTYPE}" == "darwin" ]]; then \
	    $$(brew --prefix ruby@2.7)/bin/ruby extconf.rb; \
	  elif [[ -f /etc/arch-release ]]; then \
	    ruby extconf.rb; \
	  fi; \
	  make

.PHONY: vim-go
vim-go: ~/.vim/bundle/vim-go
	cd $<; \
	  git fetch origin v1.23; \
	  git checkout FETCH_HEAD

.PHONY: .bash_profile
.bash_profile:
	if [[ "${OSTYPE}" == "darwin" ]]; then \
		rm -f ${HOME}/$@; \
		ln -s $(realpath osx/$@) ${HOME}/$@; \
	fi

.PHONY: .bashrc
.bashrc:
	if [[ -f /etc/arch-release ]]; then \
		rm -f ${HOME}/$@; \
		ln -s $(realpath arch/$@) ${HOME}/$@; \
	fi

.PHONY: .gitconfig
.gitconfig:
	rm -f ${HOME}/$@; \
	if [[ "${OSTYPE}" == "darwin" ]]; then \
		ln -s $(realpath osx/$@) ${HOME}/$@; \
	elif [[ -f /etc/arch-release ]]; then \
		ln -s $(realpath arch/$@) ${HOME}/$@; \
	fi
