#!/usr/bin/env bash
sudo rm /etc/nixos
sudo ln -s ~/NixOS/ /etc/nixos

sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release
sudo nix-channel --update
sudo nixos-rebuild switch

