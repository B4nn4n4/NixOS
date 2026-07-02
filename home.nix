{ config, pkgs, ... }:

{
  home.username = "adm-kalbf";
  home.homeDirectory = "/home/adm-kalbf";

  home.stateVersion = "25.05";

  programs.zsh.enable = true;

  programs.ssh = {
    enable = true;
    matchBlocks."github.com" = {
      identityFile = "~/.ssh/github";
      identitiesOnly = true;
    };
  };
}
