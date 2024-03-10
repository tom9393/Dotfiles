#!bin/bash

dot_config() {
	for item in $PWD/config/*; do
		TO=$HOME/.config/$(basename $item)
		FROM=$HOME/.dotfiles/config/$(basename $item)
		ln -s $FROM $TO
	done
}

home_config() {
	for item in $PWD/home/*; do
		TO=$HOME/.$(basename $item)
		FROM=$HOME/.dotfiles/home/$(basename $item)
		ln -s $FROM $TO
	done
}

home_config
dot_config
