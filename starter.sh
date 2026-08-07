#!/usr/bin/env bash
sudo rm /etc/nixos
sudo ln -s ~/NixOS/ /etc/nixos

nixos-generate-config

sudo nixos-rebuild switch

