inputs@{ options, config, lib, pkgs, ... }:
with lib;
with lib.rr-sv;
let cfg = config.rr-sv.services.vaultwarden;
in {
  options.rr-sv.services.vaultwarden = with types; {
    enable = mkBoolOpt false "Whether or not to enable vaultwarden";
  };

  config = mkIf cfg.enable {
    networking.firewall = { allowedTCPPorts = [ 53589 ]; };

    services.vaultwarden = {
      enable = true;
      bitwarden-directory-connector-cli.domain = "https://vault.russellb.dev";
      config = {
        WEB_VAULT_FOLDER =
          "${pkgs.bitwarden_rs-vault}/share/bitwarden_rs/vault";
        WEB_VAULT_ENABLED = true;
        LOG_FILE = "/var/log/bitwarden";
        WEBSOCKET_ENABLED = true;
        WEBSOCKET_ADDRESS = "0.0.0.0";
        WEBSOCKET_PORT = 3012;
        # SIGNUPS_VERIFY = true;
        # ADMIN_TOKEN = (import /etc/nixos/secret/bitwarden.nix).ADMIN_TOKEN;
        # YUBICO_CLIENT_ID =
        #   (import /etc/nixos/secret/bitwarden.nix).YUBICO_CLIENT_ID;
        # YUBICO_SECRET_KEY =
        #   (import /etc/nixos/secret/bitwarden.nix).YUBICO_SECRET_KEY;
        # YUBICO_SERVER = "https://api.yubico.com/wsapi/2.0/verify";
        # SMTP_HOST = "mx.example.com";
        # SMTP_FROM = "bitwarden@example.com";
        # SMTP_FROM_NAME = "Bitwarden_RS";
        # SMTP_PORT = 587;
        # SMTP_SECURITY = starttls;
        # SMTP_USERNAME = (import /etc/nixos/secret/bitwarden.nix).SMTP_USERNAME;
        # SMTP_PASSWORD = (import /etc/nixos/secret/bitwarden.nix).SMTP_PASSWORD;
        # SMTP_TIMEOUT = 15;
        # ROCKET_PORT = 8812;
      };
    };
    # environmentFile = "/etc/nixos/secret/bitwarden.env";

    services.nginx.virtualHosts = {
      "vault.russellb.dev" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8119";
          proxyWebsockets = true;
        };
      };
    };

    security.acme.certs."vault.russellb.dev" = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      webroot = null;
      credentialsFile = config.sops.secrets.acmecredfile.path;
    };
  };
}
