{
  disko.devices = {
    disk = {
      sda = {
        type = "disk";
        device = "/dev/disk/by-id/ata-SK_hynix_SC300B_HFS256G39MND-3510B_FS71N446311101958";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "128M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "defaults" ];
              };
            };
            luks = {
              size = "-32G";
              content = {
                type = "luks";
                name = "crypt"
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Override existing partition
                # Subvolumes must set a mountpoint in order to be mounted,
                # unless their parent is mounted
                subvolumes = {
                  "/rootfs" = {
                    mountpoint = "/";
                  };
                  "/home" = {
                    mountOptions = [ "compress=zstd" ];
                    mountpoint = "/home";
                  };
                  "/home/russ" = { };
                  "/nix" = {
                    mountOptions = [ "compress=zstd" "noatime" ];
                    mountpoint = "/nix";
                  };
                };  
              };
            };
            encryptedSwap = {
              priority = 2;
              name = "encryptedSwap";
              size = "100%";
              type = "8200";
              content = {
                type = "swap";
                encrypted = true;
                resumeDevice = true;
              };
            };
          };
        };
      };
    };
  };
}
