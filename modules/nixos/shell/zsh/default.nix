inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.shell.zsh;
in {
  options.rr-sv.shell.zsh = with types; {
    enable = mkBoolOpt false "Whether or not to enable zsh";
  };

  config = mkIf cfg.enable {
    rr-sv.home = {
      extraOptions = {
        programs.zsh = {
          enable = true;
          enableAutosuggestions = true;
          syntaxHighlighting.enable = true;
          enableCompletion = true;
          history.path = "$XDG_CACHE_HOME/zsh.history";
          autocd = true;
          dotDir = ".config/zsh";

          initExtra = ''
            # Fix an issue with tmux.
            export KEYTIMEOUT=1

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
    };
  };
}
