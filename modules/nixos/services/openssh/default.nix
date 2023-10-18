

{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.services.openssh;
  # configFiles = lib.snowfall.fs.get-files ../../../../config/ssh;


in {
  options.rr-sv.services.openssh = with types; {
    enable = mkBoolOpt false "Whether or not to enable openssh.";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
      settings.PasswordAuthentication = false;
      extraConfig = ''
        AllowAgentForwarding yes
      '';
    };
  };
}
