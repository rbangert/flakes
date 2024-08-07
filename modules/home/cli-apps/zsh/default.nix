{
  options,
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.cli-apps.zsh;
in {
  options.${namespace}.cli-apps.zsh = {
    enable = mkEnableOption "zsh";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      history.path = "$XDG_CACHE_HOME/zsh.history";
      autocd = true;
      dotDir = ".config/zsh";

      initExtra = ''
        # Fix an issue with tmux.
        export KEYTIMEOUT=1

        export EDITOR=nvim

        # Use vim bindings.
        set -o vi

        # Improved vim bindings.
        source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

        eval "$(starship init zsh)"
        eval "$(direnv hook zsh)"
      '';

      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.4.0";
            sha256 = "037wz9fqmx0ngcwl9az55fgkipb745rymznxnssr3rx9irb6apzg";
          };
        }
      ];

      # TODO add zsh aliases
      shellAliases = {
        cat = "bat";
        l = "eza --icons -alG --group-directories-first --git";
      };

      # TODO localVariables
      # TODO plugins
      # TODO prezto
      # TODO shellAliases
    };
  };
}
