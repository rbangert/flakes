inputs@{ options, config, lib, pkgs, ... }:

with lib;
with lib.rr-sv;
let
  cfg = config.rr-sv.services.code-server;

in
{
  options.rr-sv.services.code-server = with types; {
    enable = mkBoolOpt false "Whether or not to enable code-server";
  };

  config = mkIf cfg.enable {
    services.code-server = {
      enable = true;
    };

    nixpkgs.config.permittedInsecurePackages = [
      "nodejs-16.20.1"
    ];

  };
}
