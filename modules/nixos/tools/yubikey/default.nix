{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.tools.yubikey;
in {
  options.rr-sv.tools.yubikey = with types; {
    enable = mkBoolOpt false "Whether or not to enable yubikey";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      yubico-pam
      yubioath-flutter
      yubikey-manager-qt
    ];

    services.udev.packages = with pkgs; [
      yubikey-personalization
      yubikey-personalization-gui
    ];

    security.pam.services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
  };
}
