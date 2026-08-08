{ config, pkgs, ... }:

{
  imports = [
    ./nixvim.nix
  ];
  home.username = "fabian";
  home.homeDirectory = "/home/fabian";

  home.stateVersion = "25.05";

  programs.zsh.enable = true;
 
  programs.ssh = {
    enableDefaultConfig = false;
    enable = true;

    settings = {
      "*" = {
        ServerAliveInterval = 60;
      };
    };

    matchBlocks."github.com" = {
      identityFile = "~/.ssh/github";
      identitiesOnly = true;
    };

    matchBlocks."M-DE-BU-SRV-ADO" = {
      identityFile = "~/.ssh/M-DE-BU-SRV-ADO";
      identitiesOnly = true;
    };
  };

  programs.git = {
    enable = true;

    userName = "B4nn4n4";
    userEmail = "git@B4nn4n4.dev";
  };

  programs.bash = {
    enable = true;

    shellAliases = {
      ll = "ls -lah";
      rebuild = "sudo systemctl stop forticlient.service
      sudo nixos-rebuild switch --flake ~/NixOS#nixos";
    };

    sessionVariables = {
      EDITOR = "nvim";
    };

    initExtra = ''
      source ~/.config/bash/.bashrc
    '';
  };

  systemd.user.services.kanata = {
    Unit.Description = "Kanata";

    Service = {
      ExecStart = "${pkgs.kanata}/bin/kanata -c %h/.config/kanata/qwerty.kbd";
      Restart = "on-failure";
    };

    Install.WantedBy = [ "default.target" ];
  };
}
