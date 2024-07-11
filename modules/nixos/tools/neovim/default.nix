inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.tools.neovim;
  treesitterWithGrammars = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
    p.bash
    p.comment
    p.css
    p.dockerfile
    p.fish
    p.gitattributes
    p.gitignore
    p.go
    p.gomod
    p.gowork
    p.hcl
    p.javascript
    p.jq
    p.json5
    p.json
    p.lua
    p.ledger
    p.make
    p.markdown
    p.nix
    p.python
    p.rust
    p.ssh_config
    p.toml
    p.tmux
    p.typescript
    p.terraform
    p.vue
    p.yaml
    p.astro
  ]);
in {
  options.rr-sv.tools.neovim = with types; {
    enable = mkBoolOpt false "Whether or not to enable neovim";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ripgrep
      fd
      lua-language-server
      rust-analyzer-unwrapped
    ];

    rr-sv.home = {
      # file.".config/nvim" = {
      #   source = ../../../../config/nvim;
      #   recursive = true;
      # };

      file."./.local/share/nvim/nix/nvim-treesitter/" = {
        recursive = true;
        source = treesitterWithGrammars;
      };
    };

    programs.neovim = {
      enable = true;
      vimAlias = true;
    };
  };
}
