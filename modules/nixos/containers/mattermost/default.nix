inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.containers.mattermost;
in {
  options.rr-sv. containers.mattermost = with types; {
    enable = mkBoolOpt false "Whether or not to enable mattermost";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers = {
        "mattermost" = {
          image = "mattermost/mattermost-team-edition:9.4";
          ports = ["3000:3000"];
          environment = {
            DISABLE_REGISTRATION = "true";
          };
        };
      };
    };
  };
}
