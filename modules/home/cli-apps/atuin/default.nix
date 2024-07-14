{ lib, config, pkgs, namespace, ... }:
with lib;
with lib.${namespace};
let cfg = config.${namespace}.cli-apps.atuin;
in {
  options.${namespace}.cli-apps.atuin = { enable = mkEnableOption "atuin"; };

  config = mkIf cfg.enable {
    programs.atuin = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        search_mode = "fuzzy";
        keymap_mode = "vim-normal";
        inline_height = 40;
        style = "compact";
        auto_sync = true;
        sync_frequency = "5m";
        sync_address = "https://api.atuin.sh";
        # key_path = "/run/secrets/atuin_key";
      };
    };
  };
}
