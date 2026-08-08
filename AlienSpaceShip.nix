{ config, pkgs, ... }:

{
  imports = [
    ./modules/pci-passthrough.nix
  ];

  networking.hostName = "AlienSpaceShip";

  services.xserver.videoDrivers = [ "nvidia" ];

  environment.systemPackages = with pkgs; [
    steam
    discord
    telegram-desktop
    kdePackages.dolphin
    looking-glass-client
  ];


  hardware.pciPassthrough.ids = [
    "10de:2803"  # RTX 4060 GPU
    "10de:22bd"  # RTX 4060 audio
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

