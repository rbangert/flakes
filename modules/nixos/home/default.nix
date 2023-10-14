{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.rr-sv;
let cfg = config.rr-sv.home;
in
{
  imports = with inputs; [
    home-manager.nixosModules.home-manager
    nix-colors.homeManagerModules.default
  ];

  options.rr-sv.home = with types; {
    file = mkOpt attrs { }
      "A set of files to be managed by home-manager's <option>home.file</option>.";
    configFile = mkOpt attrs { }
      "A set of files to be managed by home-manager's <option>xdg.configFile</option>.";
    extraOptions = mkOpt attrs { } "Options to pass directly to home-manager.";
  };

  config = {
    rr-sv.home.extraOptions = {
      home.stateVersion = config.system.stateVersion;
      home.file = mkAliasDefinitions options.rr-sv.home.file;
      xdg.enable = true;
      xdg.configFile = mkAliasDefinitions options.rr-sv.home.configFile;
    };

    home-manager = {
      useUserPackages = true;
      users.${config.rr-sv.user.name} =
        mkAliasDefinitions options.rr-sv.home.extraOptions;
    };

    colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-storm;

  };

}
