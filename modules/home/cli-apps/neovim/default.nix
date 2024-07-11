{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.cli-apps.neovim;
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
  options.${namespace}.cli-apps.neovim = {
    enable = mkEnableOption "neovim";
  };
  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        luajitPackages.luarocks-nix
        ripgrep
        fd
        lua-language-server
        rust-analyzer-unwrapped
        terraform-ls
        gopls
        go
        nodejs
        yaml-language-server
        nil
        shellcheck
        shfmt
        ruff
        ruff-lsp
        nixfmt-rfc-style
        nixd
        nixpkgs-fmt
        # rnix-lsp
        vimwiki-markdown
        tree-sitter
        stylua
        diffuse
        fd
        gccgo13
        gnumake
      ];

      # file.".config/nvim" = {
      #   source = ../../../../config/nvim;
      #   recursive = true;
      # };

      file."./.local/share/nvim/nix/nvim-treesitter/" = {
        recursive = true;
        source = treesitterWithGrammars;
      };
    };
  };
}
