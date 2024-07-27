inputs@{ options, config, lib, pkgs, ... }:
with lib;
with lib.rr-sv;
let
  cfg = config.rr-sv.containers.webdev;
  domain = "wp-dev.rr-sv.win";

  # Auxiliary functions
  fetchPackage = { name, version, hash, isTheme }:
    pkgs.stdenv.mkDerivation rec {
      inherit name version hash;
      src = let type = if isTheme then "theme" else "plugin";
      in pkgs.fetchzip {
        inherit name version hash;
        url = "https://downloads.wordpress.org/${type}/${name}.${version}.zip";
      };
      installPhase = "mkdir -p $out; cp -R * $out/";
    };

  fetchPlugin = { name, version, hash }:
    (fetchPackage {
      name = name;
      version = version;
      hash = hash;
      isTheme = false;
    });

  fetchTheme = { name, version, hash }:
    (fetchPackage {
      name = name;
      version = version;
      hash = hash;
      isTheme = true;
    });

  # Plugins
  google-site-kit = (fetchPlugin {
    name = "google-site-kit";
    version = "1.103.0";
    hash = "sha256-8QZ4XTCKVdIVtbTV7Ka4HVMiUGkBYkxsw8ctWDV8gxs=";
  });

  # Themes
  astra = (fetchTheme {
    name = "astra";
    version = "4.1.5";
    hash = "sha256-X3Jv2kn0FCCOPgrID0ZU8CuSjm/Ia/d+om/ShP5IBgA=";
  });

in {
  options.rr-sv.containers.webdev = with types; {
    enable = mkBoolOpt false "Whether or not to enable webdev";
  };

  config = mkIf cfg.enable {
    services = {
      nginx.virtualHosts.${domain} = {
        enableACME = true;
        forceSSL = true;
      };

      wordpress = {
        webserver = "nginx";
        sites."${domain}" = {
          plugins = { inherit google-site-kit; };
          themes = { inherit astra; };
          settings = { WP_DEFAULT_THEME = "astra"; };
        };
      };
    };
  };
}
