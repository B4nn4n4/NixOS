{ config, lib, pkgs, ... }:

let
  ids = config.hardware.pciPassthrough.ids;
in
{
  options.hardware.pciPassthrough.ids = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = "PCI IDs to bind to vfio-pci";
  };

  # Kernel params using host-defined IDs
  boot.kernelParams = [
    "iommu=pt"
    "intel_iommu=on"
    "vfio-pci.ids=${lib.concatStringsSep "," ids}"
    "vfio-pci.disable_vga=1"
  ];

  boot.initrd.kernelModules = [
    "vfio"
    "vfio_pci"
    "vfio_iommu_type1"
    "vfio_virqfd"
  ];

  boot.extraModprobeConfig = ''
    options vfio-pci ids=${lib.concatStringsSep "," ids}
  '';
}

