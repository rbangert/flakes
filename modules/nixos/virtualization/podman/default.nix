inputs@{ options, config, lib, pkgs, ... }:

with lib;
with lib.rr-sv;
let
  cfg = config.rr-sv.virtualization.podman;
in
{
  options.rr-sv.virtualization.podman = with types; {
    enable = mkBoolOpt false "Whether or not to enable podman.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ podman-compose ];

    rr-sv.home.extraOptions = {
     home.shellAliases = { "docker-compose" = "podman-compose"; };
    };

    # NixOS 22.05 moved NixOS Containers to a new state directory and the old
    # directory is taken over by OCI Containers (eg. podman). For systems with
    # system.stateVersion < 22.05, it is not possible to have both enabled.
    # This option disables NixOS Containers, leaving OCI Containers available.
    # FIXME: make sure this is a deprecated option
    #boot.enableContainers = false;

  virtualisation.podman.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.package = pkgs.docker;
  virtualisation.oci-containers.backend = "docker";
  };
}
