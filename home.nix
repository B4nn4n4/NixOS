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

  programs.bash = {
    enable = true;

    shellAliases = {
      ll = "ls -lah";
      rebuild = "sudo nixos-rebuild switch --flake ~/NixOS#nixos";
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
