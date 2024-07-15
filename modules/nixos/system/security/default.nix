{
  config,
  lib,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.system.security;
  # TODO: Customize KB config
in {
  options.rr-sv.system.security = with types; {
    enable = mkBoolOpt false "Whether or not to enable security";
  };

  config = mkIf cfg.enable {
    security = {
      rtkit.enable = true;
      sudo = {
        enable = true;
        wheelNeedsPassword = false;
      };
      # TODO fix doas
      doas = {
        enable = true;

        wheelNeedsPassword = false;
        extraRules = [
          {
            users = ["russ"];
            keepEnv = true;
            persist = true;
          }
        ];
      };
      protectKernelImage = true;
      unprivilegedUsernsClone = true;
    };
  };
}
