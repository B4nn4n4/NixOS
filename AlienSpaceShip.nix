{ config, pkgs, ... }:

{
  imports = [
  ];

  networking.hostName = "AlienSpaceShip";

  services.xserver.videoDrivers = [ "nvidia" ];

  environment.systemPackages = with pkgs; [
    steam
    discord
    telegram-desktop
    kdePackages.dolphin
  ];

  #Graphics Card
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  #services.xserver.videoDrivers = [ "nvidia" ];

}

