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
