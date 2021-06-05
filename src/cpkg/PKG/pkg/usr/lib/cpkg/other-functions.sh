#!/bin/bash
#
# CPkg - an automated packaging tool fog Calmira Linux
# Copyright (C) 2021 Michail Krasnov
#
# other-functions.sh
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
# Project Page: http://github.com/Linuxoid85/cpkg
# Michail Krasnov <michail383krasnov@mail.ru>
#

#==================================================================#
#
# BASE VARIABLES
#

#==================================================================#
#
# BASE FUNCTIONS
#

# Function for print a messages on screen
function print_msg() {
	if [[ $QUIET = "true" ]]; then
		echo "$@" > /dev/null
	else
		echo -e $@
	fi
}

# Function for print a debug messages on screen
function print_dbg_msg() {
	if [[ $DBG = "false" ]]; then
		echo "$@" > /dev/null
	else
		echo -e $@
	fi
}

function test_root() {
	if [[ $(whoami) -ne "root" ]]; then
		echo -e "\e[1;31mERROR\e[0m: only root can run this program!"
		exit 0
	fi
}

# Function for a print error message on screen
function error() {
	if [ $1 = "no_pkg" ]; then
		echo -e "\e[1;31mERROR\e[0m: package $PKG doesn't exists!"
	fi
	
	if [ $1 = "no_config" ]; then
		echo -e "\e[1;31mERROR\e[0m: configurition file doesn't exists!"
	fi
	
	if [ $1 = "no_pkg_data" ]; then
		echo -e "\e[1;31mERROR\e[0m: package data doesn't exists!"
	fi
	
	if [ $1 = "no_arch" ]; then
		echo -e "\e[1;31mERROR\e[0m: package architecture $2 doesn't support on this host!"
	fi
	
	if [ $1 = "not_found_arch" ]; then
		echo -e "\e[1;31mERROR\e[0m: doesn't find ARCHITECTURE variable on config.sh!"
		
		read -p "Continue? (y/N): " run
		if [ $run = "N" ]; then
			exit 0
		fi
	fi
}

# Function to check for the presence of the
# required files and directories
function check_file() {
	# Test the cache dir
	print_dbg_msg -n "check cache dir (1) '/var/cahce/cpkg' ... "
	if test -d "/var/cache/cpkg"; then
		print_dbg_msg "done"
	else
		print_dbg_msg "fail"
		print_msg -n "\e[1;31mERROR\e[0m: cache dir (var/cache/cpkg) doesn't exists! Create it? (y/n) "
		if [[ $QUIET -eq "true" ]]; then
			mkdir -p /var/cache/cpkg
		else
			read run
			if [[ $run -eq "y" ]]; then
				mkdir -pv /var/cache/cpkg
			else
				print_msg "Critical error. Continuation of the work of the 'cpkg' is impossible."
				exit 0
			fi
		fi
	fi
	
	# Test the cache dir (2)
	print_dbg_msg -n "check cache dir (2) '/var/cache/cpkg/archives' ... "
	if test -d "/var/cache/cpkg/archives"; then
		print_dbg_msg "done"
	else
		print_dbg_msg "fail"
		print_msg -n "\e[1;31mERROR\e[0m: cache dir (var/cache/cpkg/archives) doesn't exists! Create it? (y/n) "
		if [[ $QUIET -eq "true" ]]; then
			mkdir -p /var/cache/cpkg/archives
		else
			read run
			if [[ $run -eq "y" ]]; then
				mkdir -pv /var/cache/cpkg/archives
			else
				print_msg "Critical error. Continuation of the work of the 'cpkg' is impossible."
				exit 0
			fi
		fi
	fi
	
	# Test the cpkg configs dir
	print_dbg_msg -n "check configs dir (2) '/etc/cpkg' ... "
	if test -d "/etc/cpkg"; then
		print_dbg_msg "done"
	else
		print_dbg_msg "fail"
		print_msg -n "\e[1;31mERROR\e[0m: cache dir (/etc/cpkg) doesn't exists! Create it? (y/n) "
		if [[ $QUIET -eq "true" ]]; then
			mkdir -p /etc/cpkg
			echo "System: $GetCalmiraVersion
Version cpkg: 1.0 Alpha 1

"
		else
			read run
			if [[ $run -eq "y" ]]; then
				mkdir -pv /etc/cpkg
			else
				print_msg "Critical error. Continuation of the work of the 'cpkg' is impossible."
				exit 0
			fi
		fi
	fi

	# Test the database dir
	print_dbg_msg -n "check database dir '/etc/cpkg/database/packages' ... "
	if test -d "/etc/cpkg/database/packages"; then
		print_dbg_msg "done"
	else
		print_dbg_msg "fail"
		print_msg -n "\e[1;31mERROR\e[0m: cache dir (/etc/cpkg/database/packages) doesn't exists! Create it? (y/n) "
		if [[ $QUIET -eq "true" ]]; then
			mkdir -p /etc/cpkg/database/packages
		else
			read run
			if [[ $run -eq "y" ]]; then
				mkdir -pv /etc/cpkg/database/packages
			else
				print_msg "Critical error. Continuation of the work of the 'cpkg' is impossible."
				exit 0
			fi
		fi
	fi
}

function log_msg() {
	# $1 - msg
	# $2 - result
	
	if [ -z $3 ]; then
		LOG=/var/log/cpkg.log
	else
		LOG=$3
	fi
	
	echo "[ $(date) ] [ $1 ] [ $2 ]
" >> $LOG
}
