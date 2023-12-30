inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.virtualisation.incus;
in {
  options.rr-sv.virtualisation.incus = with types; {
    enable = mkBoolOpt false "Whether or not to enable incus";
  };

  config = mkIf cfg.enable {
    virtualisation.incus = {
      enable = true;
      preseed = {
        config = [
        {
          "core.https_address" = "10.0.0.97:8443";
        }
        ];
        networks = [
        {
          config = {
            "ipv4.address" = "10.0.100.1/24";
            "ipv4.nat" = "true";
          };
          name = "incusbr0";
          type = "bridge";
        }
        ];
        profiles = [
        {
          devices = {
            eth0 = {
              name = "eth0";
              network = "incusbr0";
              type = "nic";
            };
            root = {
              path = "/";
              pool = "default";
              size = "35GiB";
              type = "disk";
            };
          };
          name = "default";
        }
        ];
        storage_pools = [
        {
          config = {
            source = "/var/lib/incus/storage-pools/default";
          };
          driver = "dir";
          name = "default";
        }
        ];
      }
    };
  };
}
