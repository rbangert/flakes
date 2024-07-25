inputs@{ options, config, lib, pkgs, ... }:
with lib;
with lib.rr-sv;
let cfg = config.rr-sv.containers.gotify;
in {
  options.rr-sv.containers.gotify = with types; {
    enable = mkBoolOpt false "Whether or not to enable gotify";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers = {
        "gotify" = {
          image = "gotify/server:2.5.0";
          ports = [ "3030:80" ];
          volumes = [ "gotify-data:/app/data" ];
          environment = {
            #GOTIFY_SERVER_KEEPALIVEPERIODSECONDS = "0";
            # GOTIFY_SERVER_LISTENADDR = "127.0.0.1";
            # GOTIFY_SERVER_SSL_ENABLED = "false";
            #GOTIFY_SERVER_SSL_REDIRECTTOHTTPS = "true";
            #GOTIFY_SERVER_SSL_LISTENADDR = ;
            #GOTIFY_SERVER_SSL_PORT = "443";
            #GOTIFY_SERVER_SSL_CERTFILE = ;
            #GOTIFY_SERVER_SSL_CERTKEY = ;
            GOTIFY_SERVER_SSL_LETSENCRYPT_ENABLED = "false";
            GOTIFY_SERVER_SSL_LETSENCRYPT_ACCEPTTOS = "false";
            GOTIFY_SERVER_SSL_LETSENCRYPT_CACHE = "certs";
            # GOTIFY_SERVER_RESPONSEHEADERS = "X-Custom-Header: \"custom value\"";
            # GOTIFY_SERVER_CORS_ALLOWORIGINS = "- \".+.example.com\"\n- \"otherdomain.com\"";
            # GOTIFY_SERVER_CORS_ALLOWMETHODS = "- \"GET\"\n- \"POST\"";
            # GOTIFY_SERVER_CORS_ALLOWHEADERS = "- \"Authorization\"\n- \"content-type\"";
            # GOTIFY_SERVER_STREAM_ALLOWEDORIGINS = "- \".+.example.com\"\n- \"otherdomain.com\"";
            GOTIFY_SERVER_STREAM_PINGPERIODSECONDS = "45";
            GOTIFY_DATABASE_DIALECT = "sqlite3";
            GOTIFY_DATABASE_CONNECTION = "data/gotify.db";
            GOTIFY_PASSSTRENGTH = "10";
            GOTIFY_UPLOADEDIMAGESDIR = "data/images";
            GOTIFY_PLUGINSDIR = "data/plugins";
            GOTIFY_REGISTRATION = "false";
            # GOTIFY_SERVER_PORT = "80";
          };
        };
      };
    };

    services.nginx.virtualHosts = {
      "gotify.russellb.dev" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:3030";
          proxyWebsockets = true;
        };
      };
    };

    security.acme.certs."gotify.russellb.dev" = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      webroot = null;
      credentialsFile = config.sops.secrets.acmecredfile.path;
    };
  };
}
