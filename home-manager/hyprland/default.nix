{pkgs, ...}: {
  imports = [
    ./hypridle.nix
    ./hyprpaper.nix
    ./hyprlock.nix
    ./hyprpanel.nix
  ];

  wayland.windowManager.hyprland = let
    screenshot = with pkgs; (writeShellScriptBin "screenshot" ''
      ${grim}/bin/grim -g "$(${slurp}/bin/slurp)" - | wl-copy
    '');
    autostart = pkgs.writeShellScriptBin "autostart" ''
      hyprctl setcursor "Bibata-Original-Ice" 20
      hyprctl hyprpaper reload ",/home/septias/pictures/wallpapers/t3_vixt2p.png"
      ${pkgs.hyprdim}/bin/hyprdim
    '';
  in {
    package = pkgs.unstable.hyprland;
    enable = true;
    systemd.enable = true;
    xwayland = {
      enable = true;
    };
    plugins = [
      pkgs.unstable.hyprlandPlugins.hyprscrolling
    ];
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
          enabled = true;
          rounding = "5";
          "col.active" = "rgb(51576d)";
          "col.inactive" = "rgb(626880)";
        };
      };

      gesture = [
        "3, horizontal, workspace"
      ];

      gestures = {
        workspace_swipe_touch = true;
        workspace_swipe_forever = true;
      };

      # https://wiki.hypr.land/Configuring/Animations
      animations = {
        enabled = true;
        bezier = [
          "pace, 0.46, 1, 0.29, 0.99"
          "overshot, 0.13, 0.99, 0.29, 1.1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
        ];
        animation = [
          # name, onoff, speed(ds), curve, style
          "windows,1,1,pace,slide"
          "fade,0,3,default"
          "workspaces,1,3,default"
          "specialWorkspace,1,1,default,fade"
          "layers,0,1,default"
        ];
      };

      dwindle = {
        pseudotile = true;
        default_split_ratio = 1.0;
      };

      debug = {
        damage_tracking = 2;
        disable_logs = false;
      };

      render.direct_scanout = 2;

      misc = {
        vfr = true;
        vrr = 0;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        animate_mouse_windowdragging = true;
        animate_manual_resizes = true;
        font_family = "JetBrainsMono Nerd Font";
      };

      exec-once = [
        "${autostart}/bin/autostart"
        "[workspace special obsidian silent] obsidian"
        "[workspace special email silent] thunderbird"
      ];

      workspace = [
        "name:social, layout:scrolling"
        "special:social, layout:scrolling"
        "special, layout:scrolling"
        "m:DP-1, layout:scroll"
        "w[tv1], gapsout:0, gapsin:0"
        "f[1], gapsout:0, gapsin:0"
      ];

      bind = [
        # Window controls
        "SUPER,Q,killactive"
        "SUPER SHIFT,Q,forcekillactive"
        "SUPER ALT,g,togglegroup"
        "SUPER,g,changegroupactive"
        "SUPER,m,fullscreen"
        "SUPER ALT,f,togglefloating"
        "SUPER,p,pin"
        "SUPER,s,togglespecialworkspace,social"
        "SUPER,o,togglespecialworkspace,obsidian"
        "SUPER,y,togglespecialworkspace,email"
        "SUPER ALT,s,exec, nu ${./sort_workspaces.nu}"
        "SUPER ALT,d,exec, nu ${./toggle_dark.nu}"

        # Start programs
        "SUPER,RETURN,exec,kitty /home/septias/coding"
        "SUPER,ö     ,exec,kitty yazi /home/septias/coding"
        "SUPER,i,exec,${screenshot}/bin/screenshot"
        "SUPER,l,exec,hyprlock"
        "SUPER,l,exec,${pkgs.playerctl}/bin/playerctl pause"
        "SUPER ALT,p,exec,${pkgs.hyprpicker}/bin/hyprpicker | wl-copy"
        "SUPER SHIFT ,s,exec,google-chrome-stable --disable-features=WaylandWpColorManagerV1"
        "SUPER,space ,exec,anyrun"
        "SUPER,e,exec,nautilus"
        "SUPER,c,exec,xdg-open https://chatgpt.com"
        "SUPER,v,exec,xdg-open https://www.wetter.com/japan/tokio/JP0TY0011.html"

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

        # Resize
        "SUPER ALT, b, resizeactive, -10% 0"
        "SUPER ALT, m, resizeactive, 10% 0"

        # Misc
        "SUPER SHIFT, t, exec, hyprpanel t bar-0 & hyprpanel t bar-1"
        "SUPER SHIFT, o, movetoworkspace, special:obsidian, class:^(obsidian)$"
      ];

      bindm = [
        "ALT, mouse:272, movewindow"
        "ALT, mouse:273, resizewindow"
      ];

      binds.hide_special_on_workspace_change = true;

      bindle = [
        ",XF86MonBrightnessUp,  exec, ${pkgs.brightnessctl}/bin/brightnessctl set +10%"
        ",XF86MonBrightnessDown,exec, ${pkgs.brightnessctl}/bin/brightnessctl set 10%-"
        ",XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 5"
        ",XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 5"
        ",XF86AudioMute,        exec, ${pkgs.pamixer}/bin/pamixer -t"
        ",XF86AudioPlay,        exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ",XF86AudioPause,       exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ",XF86AudioNext,        exec, ${pkgs.playerctl}/bin/playerctl next"
        ",XF86AudioPrev,        exec, ${pkgs.playerctl}/bin/playerctl prev"
        "SUPER ALT,n,           exec, ${pkgs.playerctl}/bin/playerctl next"
        "SUPER ALT,s,           exec, ${pkgs.playerctl}/bin/playerctl play-pause"
      ];
    };
    extraConfig = ''
      windowrule {
        name = windowrule-1
        tile = on
        match:class = ^(sioyek)$
      }

      windowrule {
        name = windowrule-2
        immediate = on
        fullscreen = on
        workspace = cs2
        match:class = ^(cs2)$
      }

      windowrule {
        name = windowrule-3
        workspace = special:social
        match:class = ^(org.telegram.desktop|signal|discord)$
      }

      windowrule {
        name = windowrule-4
        workspace = special:social
        match:title = ^(WhatsApp Web)$
      }

      windowrule {
        name = windowrule-5
        workspace = special:social
        match:title = ^(Delta Chat)$
      }

      windowrule {
        name = windowrule-6
        workspace = special:obsidian
        match:class = ^(obsidian)$
      }

      windowrule {
        name = windowrule-7
        workspace = special:email
        match:title = ^(Mozilla Thunderbird)$
      }

      windowrule {
        name = windowrule-8
        float = on
        pin = on
        size = 800 400
        move = ((monitor_w/2)) ((monitor_h/2))
        match:title = ^(Calendar Reminders)$
      }

      windowrule {
        name = windowrule-9
        float = on
        pin = on
        size = 800 400
        move = ((monitor_w/2)) ((monitor_h/2))
        match:title = ^(jurts)$
      }
    '';
  };
}
