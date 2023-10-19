inputs @ { options
, config
, lib
, pkgs
, ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.virtualisation.libvirtd;
in
{
  options.rr-sv.virtualisation.libvirtd = with types; {
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
