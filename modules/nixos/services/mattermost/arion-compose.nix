{ options, config, lib, pkgs, ... }:

with lib;
with lib.rr-sv;
let
  cfg = config.rr-sv.services.mattermost;
in
{
  options.rr-sv.services.mattermost = with types; {
    enable = mkBoolOpt false "Weather or not to enable mattermost";
  };

  config = mkIf cfg.enable { }
