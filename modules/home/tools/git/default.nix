{
  lib,
  config,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt enabled;

  cfg = config.${namespace}.tools.git;
  user = config.${namespace}.user;
in {
  options.${namespace}.tools.git = {
    enable = mkEnableOption "Git";
    userName = mkOpt types.str user.fullName "The name to configure git with.";
    userEmail = mkOpt types.str user.email "The email to configure git with.";
    signingKey = mkOpt types.str "0824BA7A7AB14E18" "The key ID to sign commits with.";
    signByDefault = mkOpt types.bool true "Whether to sign commits by default.";
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      inherit (cfg) userName userEmail;
      lfs = enabled;
      signing = {
        key = cfg.signingKey;
        inherit (cfg) signByDefault;
      };
      # ignores = {
      # };
      # hooks = {
      #   pre-commit = ./pre-commit-script;
      # };
      extraConfig = {
        color.ui = true;
        core.editor = "nvim";
        credential.helper = "store";
        init = {
          defaultBranch = "main";
        };
        pull = {
          rebase = true;
        };
        push = {
          autoSetupRemote = true;
        };
        core = {
          whitespace = "trailing-space,space-before-tab";
        };
        # safe = {
        #   directory = "${user.home}/stuff/p/config/.git";
        # };
      };
      delta = {
        enable = true;
        options = {
          dark = true;
          decorations = {
            commit-decoration-style = "bold yellow box ul";
            file-decoration-style = "none";
            file-style = "bold yellow ul";
          };
          features = "decorations";
          whitespace-error-style = "22 reverse";
        };
      };
    };
  };
}
