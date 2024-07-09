inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.desktop.hyprland;
in {
  options.rr-sv.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Whether or not to enable hyprland";
  };

  config = mkIf cfg.enable {
    #TODO: Pull in the hyprland config file
    environment.systemPackages = with pkgs; [
      hypridle
      wlsunset
      wl-clipboard
      cliphist
      grim
      gscreenshot
      ksnip
      slurp
      swaybg
      brightnessctl
      pamixer
      kitty
      polkit_gnome
      libva-utils
      fuseiso
      udiskie
      gnome.adwaita-icon-theme
      gnome.gnome-themes-extra
      gsettings-desktop-schemas
      swaynotificationcenter
      wlr-randr
      ydotool
      wl-clipboard
      hyprland-protocols
      hyprpicker
      swayidle
      swaylock
      xdg-desktop-portal-hyprland
      hyprpaper
      hyprlock
      wofi
      firefox-wayland
      swww
      xdg-utils
      xdg-desktop-portal
      qt5.qtwayland
      qt6.qmake
      qt6.qtwayland
      adwaita-qt
      adwaita-qt6
      (pkgs.python3Packages.buildPythonPackage rec {
        pname = "pyprland";
        version = "1.4.1";
        src = pkgs.fetchPypi {
          inherit pname version;
          sha256 = "sha256-JRxUn4uibkl9tyOe68YuHuJKwtJS//Pmi16el5gL9n8=";
        };
        format = "pyproject";
        propagatedBuildInputs = with pkgs; [
          python3Packages.setuptools
          python3Packages.poetry-core
          poetry
        ];
        doCheck = false;
      })
    ];

    xdg = {
      autostart.enable = true;
      portal = {
        enable = true;
        extraPortals = [pkgs.xdg-desktop-portal-hyprland];
      };
    };

    boot.plymouth = {
      enable = true;
      themePackages = with pkgs; [rr-sv.catppuccin-plymouth];
      theme = "catppuccin-mocha";
    };

    services = {
      libinput.enable = true;
      xserver = {
        enable = true;
        videoDrivers = ["modesetting"];
        excludePackages = [pkgs.xterm];
        displayManager.gdm = {
          enable = true;
          wayland = true;
        };
      };
      dbus.enable = true;
      gvfs.enable = true;
      tumbler.enable = true;
      gnome = {
        sushi.enable = true;
        gnome-keyring.enable = true;
      };
    };

    programs = {
      hyprland = {
        enable = true;
        xwayland.enable = true;
      };
      thunar = {
        enable = true;
        plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
      };
    };

    rr-sv.home = {
      file.".config/hypr/pyprland.json".text = ''
        {
          "pyprland": {
            "plugins": ["scratchpads", "magnify", "expose" ]
          },
          "scratchpads": {
            "term": {
              "command": "alacritty --class scratchpad",
              "margin": 50
            },
            "ranger": {
              "command": "kitty --class scratchpad -e ranger",
              "margin": 50
            },
            "musikcube": {
              "command": "alacritty --class scratchpad -e musikcube",
              "margin": 50
            },
            "btm": {
              "command": "alacritty --class scratchpad -e btm",
              "margin": 50
            },
            "geary": {
              "command": "geary",
              "margin": 50
            },
            "pavucontrol": {
              "command": "pavucontrol",
              "margin": 50,
              "unfocus": "hide",
              "animation": "fromTop"
            }
          }
        }
      '';
      configFile."hypr/hyprland.conf".source = ../../../../config/hypr/hyprland.conf;
      configFile."hypr/hyprlock.conf".source = ../../../../config/hypr/hyprlock.conf;
      configFile."hypr/hypridle.conf".source = ../../../../config/hypr/hypridle.conf;
      extraOptions = {
        services = {
          dunst = {
            enable = true;
            iconTheme = {
              package = pkgs.gnome3.adwaita-icon-theme;
              name = "Adwaita";
              size = "32x32";
            };
          };
          #   # TODO config kanshi: hotswap monitor configs
          # kanshi =  {
          #   enable = true;
          #   extraConfig = ''
          #   '';
          #   profiles = ``
          #   ``;
          #   https://nix-community.github.io/home-manager/options.html#opt-services.kanshi.profiles
          # };
        };
      };
    };
  };
}
