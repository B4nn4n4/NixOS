{ config, lib, ... }:

{
  options.hardware.pciPassthrough.ids = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = "PCI IDs to bind to vfio-pci";
  };

  config = let
    ids = lib.concatStringsSep "," config.hardware.pciPassthrough.ids;
  in {
    boot.kernelParams = [
      "amd_iommu=on"
      "iommu=pt"
      "vfio-pci.ids=${ids}"
      "vfio-pci.disable_vga=1"
    ];

    boot.initrd.kernelModules = [
      "vfio"
      "vfio_pci"
      "vfio_iommu_type1"
    ];

    boot.extraModprobeConfig = ''
      options vfio-pci ids=${ids}
    '';
  };
}
