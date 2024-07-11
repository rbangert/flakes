{
  lib,
  config,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf;
  cfg = config.${namespace}.tools.ssh;
in {
  options.${namespace}.tools.ssh = {
    enable = mkEnableOption "ssh";
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      extraConfig = ''
        Host *
          HostKeyAlgorithms +ssh-rsa
      '';
    };
  };
}
