{ config, lib, pkgs, ... }:

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
    environment.systemPackages = with pkgs; [
      podman-compose
      docker-client
      arion
    ];

    rr-sv.home.extraOptions = {
      home.shellAliases = { "docker-compose" = "podman-compose"; };
    };

    virtualisation = {
      docker.enable = false;
      podman = {
        enable = true;
        dockerSocket.enable = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };
  };
}
