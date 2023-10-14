{ config, lib, ... }:

with lib;
with lib.rr-sv;
let
  cfg = config.rr-sv.tools.git;
in
{
  options.rr-sv.tools.git = with types; {
    enable = mkBoolOpt false "Whether or not to enable git";
  };

  config = mkIf cfg.enable {
    rr-sv.home.extraOptions = {
      programs.git = {
        enable = true;
        userName = "rbangert";
        userEmail = "rbangert@proton.me";
        extraConfig = {
          init = { defaultBranch = "main"; };
          core = {
            excludesfile = "$NIXOS_CONFIG_DIR/scripts/gitignore";
          };
        };
      };
    };
  };
}
