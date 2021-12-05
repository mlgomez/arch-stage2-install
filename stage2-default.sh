#!/bin/bash

#####################################################################
# This is a personal installation script for stage 2 of archinstall #
# Please run this only AFTER you have installed archlinux and       #
# logged in.                                                        #
#                                                                   #
# When running archinstall on installation DO NOT install a         #
# desktop environment. This script will install a window manager    #
# for you. You may choose to install a DE over this if you wish     #
# after the script has finished setting everything up for you.      #
#                                                                   #
# This script will install all i3-gaps with polybar and a few       #
# gizmos to get you started. Enjoy!                                 #
#                                                                   #
# Script by Miguel Leiva-Gomez                                      #
#####################################################################

#######################
# !!!! IMPORTANT !!!! #
# Extra Notes         #
#######################

# Run pacman -S --needed base-devel git before running this script!


##############################################
# Initial setup. Let's get the tools we need #
##############################################

echo "Your password will be needed to enable and start some services."
echo "Type your password to continue installation. Type 'fuckoff' to cancel:"
read -r passwd

if [[ "$passwd" == "fuckoff" ]]; then
	exit 0
fi

# Set some variables for this script
workingdir=$PWD

# Create typical subdirectories for home dir if they don't exist

if [[ ! -d "$HOME/Downloads" ]]; then
	mkdir "$HOME/Downloads"
fi

if [[ ! -d "$HOME/Documents" ]]; then
	mkdir "$HOME/Documents"
fi

if [[ ! -d "$HOME/Music" ]]; then
	mkdir "$HOME/Music"
fi

if [[ ! -d "$HOME/Pictures" ]]; then
	mkdir "$HOME/Pictures"
fi

if [[ ! -d "$HOME/Videos" ]]; then
	mkdir "$HOME/Videos"
fi

# Before running package management, update system
sudo pacman -Syu --noconfirm

#########################
# Installing AUR Helper #
#########################

cd "$HOME" || exit 1

# Check if yay pkg exists from probable previous failed installation
# If it exists, remove it

if [[ -d "yay" ]]; then
	echo "Found yay directory already. Removing before installiation attempt."
	rm -rf "yay"
fi

# Download and install yay

git clone http://aur.archlinux.org/yay.git
cd "yay" || exit 1
makepkg -si --noconfirm

# NOTE: When using yay, attempt to pass --noconfirm just like with pacman
# This might help the installation process go along more smoothly.
# Echo $passwd as well so it can skip sudo

#####################
# Installing system #
#####################

# Grab all the packages needed for graphics
sudo pacman -S --needed --noconfirm xorg 
sudo pacman -S --needed --noconfirm sddm
systemctl enable sddm

# Install i3-gaps and some other tools then copy configs
# I like kate even if it's not super efficient. Sue me.
sudo pacman -S --needed --noconfirm i3-gaps
sudo pacman -S --needed --noconfirm feh
sudo pacman -S --needed --noconfirm nano
sudo pacman -S --needed --noconfirm vim
sudo pacman -S --needed --noconfirm kate
sudo pacman -S --needed --noconfirm fish
sudo pacman -S --needed --noconfirm fzf
sudo pacman -S --needed --noconfirm bat
sudo pacman -S --needed --noconfirm starship
sudo pacman -S --needed --noconfirm alacritty
sudo pacman -S --needed --noconfirm easyeffects
sudo pacman -S --needed --noconfirm neofetch
sudo pacman -S --needed --noconfirm picom
sudo pacman -S --needed --noconfirm spectacle
sudo pacman -S --needed --noconfirm dunst
sudo pacman -S --needed --noconfirm polkit-kde-agent
sudo pacman -S --needed --noconfirm rofi
sudo pacman -S --needed --noconfirm plocate

# Install yay pkgs

yay -S --needed --noconfirm polybar
yay -S --needed --noconfirm find-the-command
yay -S --needed --noconfirm exa

######################
# Configuring system #
######################


# In case .config does not exist.....
if [[ ! -d "$HOME/.config" ]]; then
	mkdir "$HOME/.config"
fi

cd "$workingdir" || exit 1
cp -r dotfiles/alacritty "$HOME/.config"
cp -r dotfiles/easyeffects "$HOME/.config"
cp -r dotfiles/fish "$HOME/.config"
cp -r dotfiles/i3 "$HOME/.config"
cp -r dotfiles/picom "$HOME/.config"
cp -r dotfiles/polybar "$HOME/.config"
cp dotfiles/starship.toml "$HOME/.config"
sudo cp dotfiles/ftc.fish /usr/share/doc/find-the-command

# Copy wallpapers and create wallpapers folder
mkdir "$HOME/Wallpapers"
find . -iname '*.jpg' -exec cp {} "$HOME/Wallpapers" \;

##################
# Start services #
##################

systemctl start sddm