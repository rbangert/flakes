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
      yubikey-manager
      yubikey-manager-qt
    ];

    programs.gnupg.agent.enable = true;

    services = {
      pcscd.enable = true;
      udev.packages = with pkgs; [
        libu2f-host
        yubikey-personalization
        yubikey-personalization-gui
      ];
    };

    security.pam = {
      services = {
      login.u2fAuth = true;
      sudo.u2fAuth = false;
    };
    u2f = {
      enable = true;
      control = "required";
      authFile = pkgs.writeText "y2f-auth-file" ''
        russ:8SLIvQszPxhVV0MtV+CdGGQRZujUSKp/Mbzy+OHqHGKf8C2XOjPklSRc4w9RShDv/eEECF0m4dutPCC/3CTOVQ==,Xt9h+IlbuNfyU/YuOgnYBFj6/fE3534ekxeLxbXl4/BUAEcXr5IXxRGflEvqXzhOxzc16SB6fpeHy5FEwnNN8Q==,es256,+presence%
      '';
    };
  };
};
}
