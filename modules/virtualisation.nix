{ config, lib, pkgs, ... }:

let
  defaultNetXml = ''
    <network>
      <name>default</name>
      <forward mode="nat"/>
      <bridge name="virbr0" stp="on" delay="0"/>
      <ip address="192.168.122.1" netmask="255.255.255.0"/>
    </network>
  '';
in
{
  options.virtualisation.fullStack.enable =
    lib.mkEnableOption "Enable full declarative libvirt + qemu stack";

  config = lib.mkIf config.virtualisation.fullStack.enable {

    # --- libvirt + qemu ---
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };

    # --- virt-manager GUI ---
    programs.virt-manager.enable = true;

    # --- polkit for virt-manager ---
    security.polkit.enable = true;

    # --- kernel modules required for KVM ---
    boot.kernelModules = [
      "kvm"
      "kvm-intel"
      "kvm-amd"
      "virtio"
      "virtio_pci"
      "vhost_net"
      "tap"
    ];

    # --- declarative libvirt network XML ---
    environment.etc."libvirt/default.xml".text = defaultNetXml;

    # --- define network if missing ---
	systemd.services.libvirt-define-default = {
	  description = "Define libvirt default network";
	  after = [ "libvirtd.service" ];
	  wantedBy = [ "multi-user.target" ];
	  serviceConfig = {
	    Type = "oneshot";
	    ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.libvirt}/bin/virsh net-define /etc/libvirt/default.xml || true'";
	    RemainAfterExit = true;
	  };
	};


    # --- start + autostart network ---
	systemd.services.libvirt-start-default = {
	  description = "Start libvirt default network";
	  after = [ "libvirt-define-default.service" ];
	  wantedBy = [ "multi-user.target" ];
	  serviceConfig = {
	    Type = "oneshot";
	    ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.libvirt}/bin/virsh net-start default || true'";
            ExecStartPost = "${pkgs.bash}/bin/bash -c '${pkgs.libvirt}/bin/virsh net-autostart default || true'";
	    RemainAfterExit = true;
	  };
	};
  };
}

