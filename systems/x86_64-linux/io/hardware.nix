{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}: let
  inherit (inputs) nixos-hardware;
in {
  imports = with nixos-hardware.nixosModules; [
    (modulesPath + "/installer/scan/not-detected.nix")
    common-cpu-intel
    common-gpu-intel
    common-pc-laptop
    common-pc-ssd
  ];

  services.thermald.enable = lib.mkDefault true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
  boot.initrd.kernelModules = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/70114134-484d-4f43-b616-aa0c23248edb";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-5a9bb454-cd9e-4d70-9360-ef096a1798de".device = "/dev/disk/by-uuid/5a9bb454-cd9e-4d70-9360-ef096a1798de";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6E0E-3C79";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/a85d7583-8e08-4c5f-81cb-546a791955e5";}
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
