# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
  {
  imports = [
    ./hardware-configuration.nix
  ];

  home-manager.users.adm-kalbf = import ./home.nix;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.dunst.enable = true;

  #Perfomance and Temp management
  systemd.tmpfiles.rules = [
    "w /sys/firmware/acpi/platform_profile - - - - balanced-performance"
  ];
  services.thermald.enable = true;

  #lidSwitch
  services.logind = {
    lidSwitch = "lock";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
  };

  #Custom boot Splashscreen
  boot.plymouth = {
    enable = true;
    theme = "bgrt";
  };
  boot.kernelParams = [
    "quiet"
    "splash"
  ];
  boot.consoleLogLevel = 0;

  #Buildgeneration Management
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  boot.loader.systemd-boot.configurationLimit = 10;

  #Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  #Kanta Prequisits
  hardware.uinput.enable = true;
  users.groups.uinput = {};

  nixpkgs.config.allowUnfree = true;
 
  services.gnome.gcr-ssh-agent.enable = false;

  # Surface Studio
  hardware.microsoft-surface.kernelVersion = "stable";
  hardware.sensor.iio.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
   # Enable SSH agend
  programs.ssh.startAgent = true;

  #Auto USB monuting
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  #Enable Graphics
  hardware.graphics.enable = true;

  # QEMU / Virtualisation
  security.polkit.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu = {
    #package = pkgs.qemu_full;
    package = pkgs.qemu_kvm;
    runAsRoot = true;
    swtpm.enable = true;
  };
  boot.kernelModules = [ "kvm-amd" "kvm-intel" "virtio" "virtio_pci" ];

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.adm-kalbf = {
    isNormalUser = true;
    description = "adm-kalbf";
    extraGroups = [
    #Default
    "networkmanager" "wheel"
    #Kanata
    "input" "uinput"
    #Virtualisation
    "libvirtd"

    ];
    packages = with pkgs; [];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    font-awesome
    noto-fonts
    noto-fonts-color-emoji
  ];

 # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  	#Applications
	alacritty
	freerdp
	teams-for-linux
	microsoft-edge
	spotify
	opencode
	#terminal extensions
	git
	fastfetch
	yazi
	neovim
	htop
	fzf
	#Scripting
	jq
	wl-clipboard
	slurp
	grim
	wofi
	cliphist
	pinentry-qt
	rofimoji
	libnotify
	#Tools
	hyprpaper
	hyprlock
	waybar
	kanata
	dunst
	blueman
	pamixer
	pavucontrol
	#Virtualisation
	virt-manager
	virt-viewer
	#qemu
	#qemu_kvm
	OVMF
	#NixVim
	ripgrep
	fd
  ];

  #Forticlient-Gui
programs.nix-ld = {
  enable = true;
  libraries = with pkgs; [
    glib
    nss
    nspr
    dbus
    atk
    cups
    libdrm
    gtk3
    pango
    cairo
    libxkbcommon
    alsa-lib
    expat

    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxcb

    mesa
    libgbm

    stdenv.cc.cc
  ];
};

services.forticlient = {
  enable = true;
  trayAutostart = true;
};
  environment.loginShellInit = ''
  	if [ "$(tty)" = "/dev/tty1" ]; then
    	exec start-hyprland
  	fi
  '';
  
  programs.hyprland = {
  	enable = true;
	withUWSM = true;
	xwayland.enable = true;
  };

  programs.neovim = {
  	enable = true;
	defaultEditor = true;
  };

   system.stateVersion = "25.11"; # Did you read the comment?
}
