{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.cli-apps.git;
in {
  options.${namespace}.cli-apps.git = {
    enable = mkEnableOption "git";
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "rbangert";
      userEmail = "rbangert@proton.me";
      extraConfig = {
        init = {defaultBranch = "main";};
        core = {
          excludesfile = "$NIXOS_CONFIG_DIR/scripts/gitignore";
        };
      };
    };
  };
}
