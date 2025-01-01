# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default
    inputs.spicetify-nix.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    # ./waybar.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
      inputs.nur.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  home = {
    username = "bibanez";
    homeDirectory = "/home/bibanez";
  };

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  # Add stuff for your user as you see fit:
  programs.neovim.enable = true;
  programs.vscode.enable = true;

  # Add Firefox GNOME theme directory
  home.file.".mozilla/firefox/nix-user-profile/chrome/firefox-gnome-theme".source = inputs.firefox-gnome-theme;
  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [pkgs.tridactyl-native];
    profiles.nix-user-profile = {
      search = {
        force = true;
        default = "DuckDuckGo";
      };
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        tridactyl
        bitwarden
      ];
      userChrome = ''
        @import "firefox-gnome-theme/userChrome.css";
      '';
      userContent = ''
        @import "firefox-gnome-theme/userContent.css";
      '';
      settings = {
        ## Firefox gnome theme ## - https://github.com/rafaelmardojai/firefox-gnome-theme/blob/7cba78f5216403c4d2babb278ff9cc58bcb3ea66/configuration/user.js
        # (copied into here because home-manager already writes to user.js)
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable customChrome.cs
        "browser.uidensity" = 0; # Set UI density to normal
        "svg.context-properties.content.enabled" = true; # Enable SVG context-propertes

        # Disable irritating first-run stuff
        "browser.disableResetPrompt" = true;
        "browser.download.panel.shown" = true;
        "browser.feeds.showFirstRunUI" = false;
        "browser.messaging-system.whatsNewPanel.enabled" = false;
        "browser.rights.3.shown" = true;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.shell.defaultBrowserCheckCount" = 1;
        "browser.startup.homepage_override.mstone" = "ignore";
        "browser.uitour.enabled" = false;
        "startup.homepage_override_url" = "";
        "trailhead.firstrun.didSeeAboutWelcome" = true;
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.bookmarks.addedImportButton" = true;

        # Don't ask for download dir
        "browser.download.useDownloadDir" = false;

        # Disable crappy home activity stream page
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;
        "browser.newtabpage.blocked" = lib.genAttrs [
          # Youtube
          "26UbzFJ7qT9/4DhodHKA1Q=="
          # Facebook
          "4gPpjkxgZzXPVtuEoAL9Ig=="
          # Wikipedia
          "eV8/WsSLxHadrTL1gAxhug=="
          # Reddit
          "gLv0ja2RYVgxKdp0I5qwvA=="
          # Amazon
          "K00ILysCaEq8+bEqV/3nuw=="
          # Twitter
          "T9nJot5PurhJSy8n038xGA=="
        ] (_: 1);

        # Disable some telemetry
        "app.shield.optoutstudies.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.sessions.current.clean" = true;
        "devtools.onboarding.telemetry.logged" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.prompted" = 2;
        "toolkit.telemetry.rejected" = true;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.telemetry.server" = "";
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.unifiedIsOptIn" = false;
        "toolkit.telemetry.updatePing.enabled" = false;

        # Disable fx accounts
        "identity.fxaccounts.enabled" = false;
        # Disable "save password" prompt
        "signon.rememberSignons" = false;
        # Harden
        "privacy.trackingprotection.enabled" = true;
        "dom.security.https_only_mode" = true;
      };
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = ["firefox.desktop"];
    "text/xml" = ["firefox.desktop"];
    "x-scheme-handler/http" = ["firefox.desktop"];
    "x-scheme-handler/https" = ["firefox.desktop"];
  };

  home.packages = with pkgs; [
    gnumake
    pavucontrol
    swww
    wofi
    playerctl
    #xfce.thunar
    insync
    calibre
    signal-desktop

    # nerd fonts
    (nerdfonts.override {
      fonts = [
        "IBMPlexMono"
        "Iosevka"
        "IosevkaTerm"
      ];
    })
  ];

  # Fonts
  fonts.fontconfig.enable = true;

  programs.kitty.enable = true;

  # Shell
  programs.fish.enable = true;
  programs.starship = {
    enable = true;
  };

  # Direnv
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  # Hyprland
  wayland.windowManager.hyprland = {
    enable = false;
    systemd.enable = false;
    xwayland.enable = true;
    settings = {
      "$mod" = "SUPER";
      "$menu" = "tofi-drun --drun-launch=true";
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];
      bindle = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-"
      ];
      bindl = [
        # media controls
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"

        # volume
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];
      bind =
        [
          "$mod, F, exec, firefox"
          "$mod, T, exec, kitty"
          "$mod SHIFT, Q, killactive"
          "$mod, D, exec, $menu"
        ]
        ++ (
          # Workspaces
          builtins.concatLists (builtins.genList (
              x: let
                ws = let
                  c = (x + 1) / 10;
                in
                  builtins.toString (x + 1 - (c * 10));
              in [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
            )
            10)
        );
      input = {
        kb_layout = "us,es";
        kb_options = "grp:win_space_toggle";
      };
      exec-once = [
        "waybar"
        "hyprctl setcursor Bibata-Modern-Classic 24"
      ];
    };
  };
  services.mako.enable = true;
  programs.tofi = {
    enable = true;
    settings = {
      width = "100%";
      height = "100%";
      border-width = 0;
      outline-width = 0;
      padding-left = "35%";
      padding-top = "35%";
      result-spacing = 25;
      num-results = 5;
      font = "monospace";
      background-color = "#000A";
    };
  };

  # GTK
  home.pointerCursor = {
    gtk.enable = false;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  gtk = {
    enable = false;

    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };

  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  in {
    enable = true;
    theme = spicePkgs.themes.default;
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Bernat Ibáñez Martínez";
    userEmail = "personal@bibanez.xyz";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
