{pkgs, ...}: {
  imports = [
    ./hypridle.nix
    ./hyprpaper.nix
    ./hyprlock.nix
    ./hyprpanel.nix
  ];

  home.packages = with pkgs; [
    hyprsunset
    easyeffects
    (writeShellScriptBin "screenshot" ''
      ${grim}/bin/grim -g "$(${slurp}/bin/slurp)" - | wl-copy
    '')
    (writeShellScriptBin "screenshot-edit" ''
      wl-paste | ${swappy}/bin/swappy -f -
    '')
  ];
  wayland.windowManager.hyprland = {
    package = pkgs.hyprland;
    enable = true;
    systemd.enable = true;
    xwayland = {
      enable = true;
    };
    plugins = [];
    settings = {
      general = {
        gaps_out = 10;
        gaps_in = 5;
        border_size = 0;
        allow_tearing = true;
        layout = "dwindle";
      };

      input = {
        kb_layout = "de";
        kb_variant = "neo";
        kb_model = "p4104";
        kb_options = "terminate:ctrl_alt_bksp";
        follow_mouse = 1;
        repeat_delay = 220;
        repeat_rate = 45;
        accel_profile = "flat";
        touchpad = {
          natural_scroll = 1;
          disable_while_typing = true;
        };
      };

      decoration = {
        dim_inactive = true;
        dim_strength = 0.2;
        rounding = 5;
      };

      group = {
        auto_group = true;
        groupbar = {
          enabled = false;
          "col.active" = "rgb(51576d)";
          "col.inactive" = "rgb(626880)";
          rounding = "5";
        };
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_forever = true;
      };

      # https://wiki.hypr.land/Configuring/Animations
      animations = {
        enabled = true;
        first_launch_animation = false;
        bezier = [
          "pace, 0.46, 1, 0.29, 0.99"
          "overshot, 0.13, 0.99, 0.29, 1.1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
        ];
        animation = [
          "windows,1,3,default"
          "fade,1,3,default"
          "workspaces,1,3,default"
          "specialWorkspace,1,1,default,fade"
        ];
      };

      dwindle = {
        pseudotile = true; # enable pseudotiling on dwindle
        default_split_ratio = 1.0;
      };

      debug = {
        damage_tracking = 2; # leave it on 2 (full) unless you hate your GPU and want to make it suffer!
        disable_logs = false;
      };

      opengl.nvidia_anti_flicker = true;
      binds.hide_special_on_workspace_change = true;
      render.direct_scanout = 2;

      misc = {
        vfr = true;
        vrr = 0;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        animate_mouse_windowdragging = true;
        animate_manual_resizes = true;
        font_family = "JetBrainsMono Nerd Font";
        new_window_takes_over_fullscreen = 2;
      };

      exec-once = let
        autostart = pkgs.writeShellScriptBin "autostart" ''
          pkill hyprsunset
          hyprsunset -t 5000 &
          hyprctl setcursor "Bibata-Original-Ice" 20
          gnome-keyring-daemon --start --components=secrets,ssh
          ${pkgs.hyprdim}/bin/hyprdim
          eval $(ssh-agent)
        '';
      in [
        "${autostart}/bin/autostart"
        "[workspace special obsidian silent] obsidian"
        "[workspace special email silent] thunderbird"
        # "[workspace special social silent] deltachat"
      ];

      windowrulev2 = [
        "monitor 1,class:^(deltachat-tauri)$"
        "fullscreenstate 0 0,class:^(deltachat-tauri)$"
        "tile,class:^(deltachat-tauri)$"
        "noinitialfocus,class:^(deltachat-tauri)$"
        "tile,class:^(sioyek)$"
        "workspace special:social,class:^(org.telegram.desktop|signal|discord)$"
        "workspace special:social,title:^(WhatsApp Web)$"
        "workspace special:social,title:^(Delta Chat)$"
        "workspace special:obsidian,class:^(obsidian)$"
        "workspace special:email,class:^(thunderbird)$"
        "workspace cs2,class:^(cs2)$"
        "immediate,class:^(cs2)$"
        "fullscreen,class:^(cs2)$"
      ];

      bind = [
        # Window controls
        "SUPER,Q,killactive"
        "SUPER SHIFT,Q,forcekillactive"
        "SUPER,g,togglegroup"
        "SUPER,m,fullscreen"
        "SUPER,p,pin"
        "SUPER SHIFT,f,togglefloating"
        "SUPER,c,centerwindow"
        "SUPER,s,togglespecialworkspace,social"
        "SUPER,o,togglespecialworkspace,obsidian"
        "SUPER,y,togglespecialworkspace,email"

        # Start programs
        "SUPER,RETURN,exec,kitty /home/septias/coding"
        ",Print,exec,screenshot"
        "SUPER,l,exec,hyprlock"
        "SUPER,l,exec,${pkgs.playerctl}/bin/playerctl play-pause"
        "SUPER,i,exec,screenshot"
        "SUPER,Print,exec,screenshot-edit"
        "SUPER SHIFT,s,exec,google-chrome-stable"
        "SUPER,space,exec,anyrun"
        "SUPER,e,exec,nautilus"
        "SUPER,c,exec, xdg-open https://chatgpt.com"

        # Focus windows
        "SUPER, b, focuswindow, class:google-chrome"

        # Move focus
        "SUPER,r,workspace,-1"
        "SUPER,t,workspace,+1"
        "SUPER,n,cyclenext"
        "SUPER,d,focusmonitor,+1"
        "SUPER SHIFT,d,movewindow,mon:+1"
        "SUPER,z,focuscurrentorlast"

        # Move window
        "SUPER ALT, t, movetoworkspace, +1"
        "SUPER ALT, r, movetoworkspace, -1"
        "SUPER ALT, d, exec, dconf write /org/gnome/desktop/interface/color-scheme \"'prefer-dark'\""
        "SUPER ALT, y, exec, dconf write /org/gnome/desktop/interface/color-scheme \"'prefer-light'\""

        # Misc
        "SUPER SHIFT, t, exec, hyprpanel t bar-0 & hyprpanel t bar-1"
        "SUPER SHIFT, o, movetoworkspace, special:obsidian, class:^(obsidian)$"
      ];

      bindm = [
        "ALT, mouse:272, movewindow"
        "ALT, mouse:273, resizewindow"
      ];

      bindle = [
        # Backlight Keys
        ",XF86MonBrightnessUp,exec, ${pkgs.brightnessctl}/bin/brightnessctl set +10%"
        ",XF86MonBrightnessDown,exec, ${pkgs.brightnessctl}/bin/brightnessctl set 10%-"
        # Volume Keys
        ",XF86AudioRaiseVolume,exec, ${pkgs.pamixer}/bin/pamixer -i 5"
        ",XF86AudioLowerVolume,exec, ${pkgs.pamixer}/bin/pamixer -d 5"
        ",XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t"
        ",XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        "SUPER ALT,s, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ",XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ",XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
        "SUPER ALT,n, exec, ${pkgs.playerctl}/bin/playerctl next"
        ",XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl prev"
      ];
    };

    extraConfig = ''
      env = XDG_SESSION_TYPE,wayland
      env = WLR_NO_HARDWARE_CURSORS,1
      env = QT_QPA_PLATFORMTHEME,wayland
      env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1

      submap=music
      bind=,escape,submap,reset
      submap=reset

    '';
  };
}
