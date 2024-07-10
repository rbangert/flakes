{
  lib,
  pkgs,
  config,
  osConfig ? {},
  format ? "unknown",
  namespace,
  ...
}:
with lib.${namespace}; {
  rr-sv = {
    user = {
      enable = true;
      name = config.snowfallorg.user.name;
    };
    cli-apps = {
      zsh = enabled;
      tmux = enabled;
      home-manager = enabled;
    };
    tools = {
      ssh = enabled;
      git = enabled;
      direnv = enabled;
    };
  };
  home = {
    packages = with pkgs; [
      neovim
      firefox
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };

    shellAliases = {
      vimdiff = "nvim -d";
    };
  };
}
