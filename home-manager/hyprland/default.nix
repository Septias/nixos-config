{
  pkgs,
  inputs,
  ...
}: let
  oxocarbon_background = "161616";
  background = "rgba(11111B00)";
  catppuccin_border = "rgba(b4befeee)";
  opacity = "0.95";
  transparent_gray = "rgba(666666AA)";
  gsettings = "${pkgs.glib}/bin/gsettings";
  gnomeSchema = "org.gnome.desktop.interface";
in {
  imports = [
    ./gtk
    ./swww
    ./waybar
    ./wofi
  ];
  nixpkgs = {
    overlays = with inputs; [
      # neovim-nightly-overlay.overlay
      (
        final: prev: {
          sf-mono-liga-bin = prev.stdenvNoCC.mkDerivation {
            pname = "sf-mono-liga-bin";
            version = "dev";
            src = sf-mono-liga-src;
            dontConfigure = true;
            installPhase = ''
              mkdir -p $out/share/fonts/opentype
              cp -R $src/*.otf $out/share/fonts/opentype/
            '';
          };

          monolisa-script = prev.stdenvNoCC.mkDerivation {
            pname = "monolisa";
            version = "dev";
            src = monolisa-script;
            dontConfigure = true;
            installPhase = ''
              mkdir -p $out/share/fonts/opentype
              cp -R $src/*.ttf $out/share/fonts/opentype/
            '';
          };

          berkeley = prev.stdenvNoCC.mkDerivation {
            pname = "berkeley";
            version = "dev";
            src = berkeley-mono;
            dontConfigure = true;
            installPhase = ''
              mkdir -p $out/share/fonts/opentype
              cp -R $src/*.otf $out/share/fonts/opentype/
            '';
          };
        }
      )
    ];
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = 1;
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    grim # Grab images from a Wayland compositor
    slurp # Select a region in a Wayland compositor
    swappy # A Wayland native snapshot editing tool, inspired by Snappy on macOS
    catppuccin-cursors.frappeSky
    easyeffects

    ## Fonts
    dejavu_fonts
    font-awesome
    fira-code-symbols
    material-design-icons
    (nerdfonts.override {fonts = ["FiraMono" "JetBrainsMono"];})
    noto-fonts
    powerline-symbols
    monolisa-script
    sf-mono-liga-bin
    berkeley

    (writeShellScriptBin "screenshot" ''
      grim -g "$(slurp)" - | wl-copy
    '')
    (writeShellScriptBin "screenshot-edit" ''
      wl-paste | swappy -f -
    '')
    (writeShellScriptBin "autostart" ''
      # Variables
      config=$HOME/.config/hypr
      scripts=$config/scripts

      # Waybar
      pkill waybar
      $scripts/launch_waybar &
      # $scripts/tools/dynamic &

      # Wallpaper
      swww kill
      swww init

      # Dunst (Notifications)
      pkill dunst
      dunst &

      # Cursor
      gsettings set org.gnome.desktop.interface cursor-theme "Catppuccin-Frappe-Sky-Cursors"
      gsettings set org.gnome.desktop.interface cursor-size 30
      hyprctl setcursor "Catppuccin-Mocha-Mauve-Cursors" 30
    '')

    (writeShellScriptBin "importGsettings" ''
      config="/home/redyf/.config/gtk-3.0/settings.ini"
      if [ ! -f "$config" ]; then exit 1; fi
      gtk_theme="$(grep 'gtk-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      icon_theme="$(grep 'gtk-icon-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      cursor_theme="$(grep 'gtk-cursor-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      font_name="$(grep 'gtk-font-name' "$config" | sed 's/.*\s*=\s*//')"
      ${gsettings} set ${gnomeSchema} gtk-theme "$gtk_theme"
      ${gsettings} set ${gnomeSchema} icon-theme "$icon_theme"
      ${gsettings} set ${gnomeSchema} cursor-theme "$cursor_theme"
      ${gsettings} set ${gnomeSchema} font-name "$font_name"
    '')
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland = {
      enable = true;
    };
    settings = {
      "$mainMod" = "SUPER";
      monitor = [
        "DP-2,1920x1080@144,0x0,1"
        "DP-1,1920x1080@60,1920x0, 1"
      ];

      cursor = {
        # no_hardware_cursors = true;
      };

      input = {
        kb_layout = "de";
        kb_variant = "neo";
        kb_model = "p4104";
        kb_options = "terminate:ctrl_alt_bksp";
        kb_rules = "";

        follow_mouse = 1;
        repeat_delay = 140;
        repeat_rate = 30;
        accel_profile = "flat";
        sensitivity = 0;
        force_no_accel = 1;
        touchpad = {
          natural_scroll = 1;
        };
      };

      general = {
        gaps_in = 1;
        gaps_out = 2;
        border_size = 3;
        "col.active_border" = "${catppuccin_border}";
        "col.inactive_border" = "${transparent_gray}";
        layout = "dwindle";
        apply_sens_to_raw = 1; # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)
      };

      decoration = {
        rounding = 12;
        shadow_ignore_window = true;
        drop_shadow = true;
        shadow_range = 20;
        shadow_render_power = 3;
        "col.shadow" = "rgb(${oxocarbon_background})";
        "col.shadow_inactive" = "${background}";
        blur = {
          enabled = true;
          size = 4;
          passes = 2;
          new_optimizations = true;
          ignore_opacity = true;
          noise = 0.0117;
          contrast = 1.3;
          brightness = 1;
          xray = true;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "pace,0.46, 1, 0.29, 0.99"
          "overshot,0.13,0.99,0.29,1.1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
        ];
        animation = [
          "windowsIn,1,6,md3_decel,slide"
          "windowsOut,1,6,md3_decel,slide"
          "windowsMove,1,6,md3_decel,slide"
          "fade,1,10,md3_decel"
          "workspaces,1,9,md3_decel,slide"
          "workspaces, 1, 6, default"
          "specialWorkspace,1,8,md3_decel,slide"
          "border,1,10,md3_decel"
        ];
      };

      misc = {
        vfr = true; # misc:no_vfr -> misc:vfr. bool, heavily recommended to leave at default on. Saves on CPU usage.
        vrr = 0; # misc:vrr -> Adaptive sync of your monitor. 0 (off), 1 (on), 2 (fullscreen only). Default 0 to avoid white flashes on select hardware.
      };

      dwindle = {
        pseudotile = true; # enable pseudotiling on dwindle
        default_split_ratio = 1.0;
      };

      master = {
        new_is_master = true;
        no_gaps_when_only = false;
      };

      debug = {
        damage_tracking = 2; # leave it on 2 (full) unless you hate your GPU and want to make it suffer!
      };

      exec-once = [
        "autostart"
        "easyeffects --gapplication-service" # Starts easyeffects in the background
        # "importGsettings"
      ];

      bind = [
        "SUPER,Q,killactive,"
        "SUPER,S,togglefloating,"
        "SUPER,g,togglegroup"

        # Move focus
        "SUPER,t,movefocus,r"
        "SUPER,r,movefocus,l"
        "SUPER,left,movefocus,l"
        "SUPER,down,movefocus,d"
        "SUPER,up,movefocus,u"
        "SUPER,right,movefocus,r"

        "SUPER,1,workspace,1"
        "SUPER,2,workspace,2"
        "SUPER,3,workspace,3"
        "SUPER,4,workspace,4"
        "SUPER,5,workspace,5"
        "SUPER,6,workspace,6"
        "SUPER,7,workspace,7"
        "SUPER,8,workspace,8"

        # Move window
        "SUPER ALT, t, movewindow, r"
        "SUPER ALT, r, movewindow, l"
        "SUPER SHIFT, left, movewindow, l"
        "SUPER SHIFT, right, movewindow, r"
        "SUPER SHIFT, up, movewindow, u"
        "SUPER SHIFT, down, movewindow, d"

        #---------------------------------------------------------------#
        # Move active window to a workspace with mainMod + ctrl + [0-9] #
        #---------------------------------------------------------------#
        # "SUPER $mainMod CTRL, 1, movetoworkspace, 1"
        # "SUPER $mainMod CTRL, 2, movetoworkspace, 2"
        # "SUPER $mainMod CTRL, 3, movetoworkspace, 3"
        # "SUPER $mainMod CTRL, 4, movetoworkspace, 4"
        # "SUPER $mainMod CTRL, 5, movetoworkspace, 5"
        # "SUPER $mainMod CTRL, 6, movetoworkspace, 6"
        # "SUPER $mainMod CTRL, 7, movetoworkspace, 7"
        # "SUPER $mainMod CTRL, 8, movetoworkspace, 8"
        # "SUPER $mainMod CTRL, 9, movetoworkspace, 9"
        # "SUPER $mainMod CTRL, 0, movetoworkspace, 10"
        # "SUPER $mainMod CTRL, left, movetoworkspace, -1"
        # "SUPER $mainMod CTRL, right, movetoworkspace, +1"
        # same as above, but doesnt switch to the workspace
        "SUPER $mainMod SHIFT, 1, movetoworkspacesilent, 1"
        "SUPER $mainMod SHIFT, 2, movetoworkspacesilent, 2"
        "SUPER $mainMod SHIFT, 3, movetoworkspacesilent, 3"
        "SUPER $mainMod SHIFT, 4, movetoworkspacesilent, 4"
        "SUPER $mainMod SHIFT, 5, movetoworkspacesilent, 5"
        "SUPER $mainMod SHIFT, 6, movetoworkspacesilent, 6"
        "SUPER $mainMod SHIFT, 7, movetoworkspacesilent, 7"
        "SUPER $mainMod SHIFT, 8, movetoworkspacesilent, 8"

        "SUPER,RETURN,exec,kitty"
        ",Print,exec,screenshot"
        "SUPER,Print,exec,screenshot-edit"
        "SUPER,o,exec,obsidian"
        "SUPER SHIFT,C,exec,wallpaper"
        "SUPER,z,exec,waybar"
        "SUPER,space,exec,wofi --show drun -I -s ~/.config/wofi/style.css DP-3"
      ];

      bindm = [
        # Mouse binds
        "SUPER,mouse:272,movewindow"
        "SUPER,mouse:273,resizewindow"
      ];

      # bindle = [
      #     # Backlight Keys
      #     ",XF86MonBrightnessUp,exec,light -A 5"
      #     ",XF86MonBrightnessDown,exec,light -U 5"
      #     # Volume Keys
      #     ",XF86AudioRaiseVolume,exec,pactl set-sink-volume @DEFAULT_SINK@ +5%  "
      #     ",XF86AudioLowerVolume,exec,pactl set-sink-volume @DEFAULT_SINK@ -5%  "
      # ];
      # bindl = [
      #     ",switch:on:Lid Switch, exec, swaylock -f -i ~/photos/wallpapers/wallpaper.png"
      #     ",switch:off:Lid Switch, exec, swaylock -f -i ~/photos/wallpapers/wallpaper.png"
      # ];

      windowrule = [
        # Window rules
        "tile,title:^(kitty)$"
        "float,title:^(fly_is_kitty)$"
        "tile,^(Spotify)$"
        "tile,^(wps)$"
      ];

      windowrulev2 = [
        "opacity ${opacity} ${opacity},class:^(thunar)$"
        "opacity ${opacity} ${opacity},class:^(discord)$"
        "opacity ${opacity} ${opacity},class:^(st-256color)$"
        "float,class:^(pavucontrol)$"
        "float,class:^(file_progress)$"
        "float,class:^(confirm)$"
        "float,class:^(dialog)$"
        "float,class:^(download)$"
        "float,class:^(notification)$"
        "float,class:^(error)$"
        "float,class:^(confirmreset)$"
        "float,title:^(Open File)$"
        "float,title:^(branchdialog)$"
        "float,title:^(Confirm to replace files)$"
        "float,title:^(File Operation Progress)$"
        "float,title:^(mpv)$"
        "opacity 1.0 1.0,class:^(wofi)$"
      ];
    };

    # Submaps
    # extraConfig = [
    # "gsettings set org.gnome.desktop.interface cursor-theme macOS-BigSur"
    #        source = ~/.config/hypr/themes/catppuccin-macchiato.conf
    #        source = ~/.config/hypr/themes/oxocarbon.conf
    #        env = GBM_BACKEND,nvidia-drm
    #        env = LIBVA_DRIVER_NAME,nvidia
    #        env = XDG_SESSION_TYPE,wayland
    #        env = __GLX_VENDOR_LIBRARY_NAME,nvidia
    #        env = WLR_NO_HARDWARE_CURSORS,1
    #        # will switch to a submap called resize
    #        bind=$mainMod,R,submap,resize
    #
    #        # will start a submap called "resize"
    #        submap=resize
    #
    #        # sets repeatable binds for resizing the active window
    #        binde=,L,resizeactive,15 0
    #        binde=,H,resizeactive,-15 0
    #        binde=,K,resizeactive,0 -15
    #        binde=,J,resizeactive,0 15
    #
    #        # use reset to go back to the global submap
    #        bind=,escape,submap,reset
    #        bind=$mainMod,R,submap,reset
    #
    #        # will reset the submap, meaning end the current one and return to the global one
    #        submap=reset
    # ];
  };

  # Hyprland configuration files
  xdg.configFile = {
    "hypr/store/dynamic_out.txt".source = ./store/dynamic_out.txt;
    "hypr/store/prev.txt".source = ./store/prev.txt;
    "hypr/store/latest_notif".source = ./store/latest_notif;
    "hypr/scripts/wall".source = ./scripts/wall;
    "hypr/scripts/launch_waybar".source = ./scripts/launch_waybar;
    "hypr/scripts/tools/dynamic".source = ./scripts/tools/dynamic;
    "hypr/scripts/tools/expand".source = ./scripts/tools/expand;
    "hypr/scripts/tools/notif".source = ./scripts/tools/notif;
    "hypr/scripts/tools/start_dyn".source = ./scripts/tools/start_dyn;
  };
}
