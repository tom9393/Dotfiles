#!bin/bash

dot_config() {
	for dotconf in $PWD/config/*; do
		TO=$HOME/.config/$(basename $dotconf)
		if [[ -e $TO ]] && [[ -L $TO ]]; then
			echo "$TO already exists"
		else
			FROM=$dotconf
			ln -sn $FROM $TO
		fi
	done
}

home_config() {
	for homeconf in $PWD/home/*; do
		TO=$HOME/.$(basename $homeconf)
		if [[ -e $TO ]] && [[ -L $TO ]]; then
			echo "$TO already exists"
		else
			FROM=$homeconf
			ln -s $FROM $TO
		fi
	done
}

dot_config
home_config
