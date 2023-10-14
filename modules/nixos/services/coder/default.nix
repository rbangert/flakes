inputs@{ options, config, lib, pkgs, ... }:

with lib;
with lib.rr-sv;
let
  cfg = config.rr-sv.development.coder;

in
{
  options.rr-sv.development.coder = with types; {
    enable = mkBoolOpt false "Whether or not to enable coder";
  };

  config = mkIf cfg.enable {

    services.postgresql.package = pkgs.postgresql_13;
    services.postgresql.ensureDatabases = [ "coder" ];
    services.postgresql.enable = true;

    virtualisation.oci-containers.containers = {

      coder = {
        extraOptions = [ "--network=host" ];
        image = "ghcr.io/coder/coder:latest";
        user = "root";
        # TODO: Investigate -- environmentFiles = [ config.age.secrets.ghuntley-dev-coder-secrets.path ];
        volumes = [
          "/srv/coder:/home/coder:cached"
          "/var/run/docker.sock:/var/run/docker.sock"
          "/var/run/libvirt/libvirt-sock:/var/run/libvirt/libvirt-sock"
          "/var/lib/libvirt/images:/var/lib/libvirt/images"
          "/dev/kvm:/dev/kvm"
        ];
        ports = [
          "3000:3000"
        ];

        environment = {
          CODER_HTTP_ADDRESS = "10.0.0.101:3000";
          CODER_ACCESS_URL = "https://code.rr-sv.win";
          CODER_DISABLE_PASSWORD_AUTH = "false";
          CODER_EXPERIMENTS = "*";
          CODER_OAUTH2_GITHUB_ALLOW_EVERYONE = "true";
          CODER_OAUTH2_GITHUB_ALLOW_SIGNUPS = "false";
          CODER_OIDC_ALLOW_SIGNUPS = "false";
          CODER_REDIRECT_TO_ACCESS_URL = "false";
          CODER_SECURE_AUTH_COOKIE = "false";
          # CODER_SSH_HOSTNAME_PREFIX = "ghuntley-dev";
          CODER_VERBOSE = "true";
          CODER_TELEMETRY = "true";
          CODER_UPDATE_CHECK = "true";
          CODER_WILDCARD_ACCESS_URL = "*.rr-sv.win";
          HTTP_PROXY = "http://172.245.210.126";
          HTTPS_PROXY = "https://172.245.210.126";
          CODER_PG_CONNECTION_URL = "postgres://coder:coder@0.0.0.0/coder?sslmode=disable";
          #TF_LOG = "DEBUG";
        };
      };
    };
  };
}
