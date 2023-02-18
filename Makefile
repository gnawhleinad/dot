.PHONY: qutebrowser
qutebrowser:
	if [[ -f /etc/arch-release ]]; then \
		cp .qutebrowser/config.py ~/.config/qutebrowser/; \
	fi

.PHONY: youcompleteme
youcompleteme: ~/.config/nvim/plugged/YouCompleteMe
	python3.10 -m pip install setuptools; \
	  python3.10 -m pip install --upgrade pynvim; \
	  cd $<; \
	  python3.10 install.py \
	    --clangd-completer \
	    --ts-completer \
	    --rust-completer

.PHONY: .bashrc
.bashrc:
	if [[ "$${OSTYPE}" =~ darwin.* ]]; then \
		rm -f ${HOME}/$@; \
		ln -s $(realpath osx/$@) ${HOME}/$@; \
	elif [[ -f /etc/arch-release ]]; then \
		rm -f ${HOME}/$@; \
		ln -s $(realpath arch/$@) ${HOME}/$@; \
	fi

.PHONY: .bash_profile
.bash_profile:
	if [[ "$${OSTYPE}" =~ darwin.* ]]; then \
		rm -f ${HOME}/$@; \
		ln -s $(realpath osx/$@) ${HOME}/$@; \
	fi

.PHONY: .gitconfig
.gitconfig:
	rm -f ${HOME}/$@; \
	if [[ "${OSTYPE}" =~ darwin.* ]]; then \
		ln -s $(realpath osx/$@) ${HOME}/$@; \
	elif [[ -f /etc/arch-release ]]; then \
		ln -s $(realpath arch/$@) ${HOME}/$@; \
	fi
