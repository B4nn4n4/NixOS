{ config, pkgs, ... }:

{
  imports = [
    ./modules/pci-passthrough.nix
    ./modules/win11-vm-nix
    ./modules/virtualisation.nix
  ];

  networking.hostName = "AlienSpaceShip";

  environment.systemPackages = with pkgs; [
    steam
    discord
    telegram-desktop
    kdePackages.dolphin
    looking-glass-client
  ];

  virtualisation.fullStack.enable = true;

  # PCI Passthrough
  hardware.pciPassthrough.ids = [
    "10de:2803"  # RTX 4060 Ti
    "10de:22bd"  # RTX 4060 Ti audio
  ];

  # Host graphics: AMD iGPU
  services.xserver.videoDrivers = [ "amdgpu" ];
}
