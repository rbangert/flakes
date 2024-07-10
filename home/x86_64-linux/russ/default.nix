{
  lib,
  pkgs,
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
      #     zsh = enabled;
      #     neovim = enabled;
      home-manager = enabled;
    };

    tools = {
      git = enabled;
      direnv = enabled;
    };
  };
  home.packages = with pkgs; [
    neovim
    firefox
  ];

  sessionVariables = {
    EDITOR = "nvim";
  };

  shellAliases = {
    vimdiff = "nvim -d";
  };
}
