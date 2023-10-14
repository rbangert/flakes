inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.services.taskserver;
in {
  options.rr-sv.services.taskserver = with types; {
    enable = mkBoolOpt false "Whether or not to enable taskserver";
  };

  config = mkIf cfg.enable {
    # rr-sv.home.configFile."alacritty/alacritty.yml".source = ./config/alacritty.yml;

    services.taskserver = {
      enable = true;
      # dataDir = "/p/tasks";
      organisations.rr-sv.users = ["russ" "rebecca"];
      # manual.server.key = ;
      # manual.server.cert = ;
    };
  };
}
