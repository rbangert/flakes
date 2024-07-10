{
  lib,
  pkgs,
  config,
  options,
  osConfig ? {},
  format ? "unknown",
  namespace,
  ...
}:
with lib.${namespace}; {
  rr-sv = {
    cli-apps = {
      home-manager = enabled;
      direnv = enabled;
      git = enabled;
      starship = enabled;
      tmux = enabled;
      zsh = enabled;
      atuin = enabled;
    };
    desktop = {
      ags = enabled;
    };
  };
}
