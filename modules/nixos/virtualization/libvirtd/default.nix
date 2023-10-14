inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.virtualization.libvirtd;
in {
  options.rr-sv.virtualization.libvirtd = with types; {
    enable = mkBoolOpt false "Whether or not to enable libvirtd.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      qemu
      qemu_kvm
      libguestfs
      virt-manager
    ];

    virtualisation.libvirtd = {
      enable = true;
      onBoot = "start";
      onShutdown = "suspend";
      allowedBridges = ["eno0"];
      qemu.ovmf.enable = true;
      qemu.swtpm.enable = true;
      qemu.swtpm.package = pkgs.swtpm;
    };

    boot.extraModprobeConfig = "options kvm_intel nested=1";

    security.polkit.enable = true;

    # reload vm configs from //services/*/libvirt/guests.nix
    systemd.services."libvirtd".reloadIfChanged = true;
  };
}
