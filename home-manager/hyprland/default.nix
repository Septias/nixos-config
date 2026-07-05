{pkgs, ...}: {
  imports = [
    ./hypridle.nix
    ./hyprpaper.nix
    ./hyprlock.nix
    ./hyprsunset.nix
    ./wayle.nix
  ];

  wayland.windowManager.hyprland = let
    screenshot = with pkgs; (writeShellScriptBin "screenshot" ''
      ${grim}/bin/grim -g "$(${slurp}/bin/slurp)" - | wl-copy
    '');
    autostart = pkgs.writeShellScriptBin "autostart" ''
      hyprctl setcursor "Bibata-Original-Ice" 20
      ${pkgs.hyprdim}/bin/hyprdim
    '';
  in {
    package = pkgs.unstable.hyprland;
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
    configType = "lua";
    extraConfig = ''
        hl.env("HYPRCURSOR_THEME", "MyCursor")
        hl.env("HYPRCURSOR_SIZE", "20")


        hl.curve("pace", { type = "bezier", points = { { 0.46, 1 }, { 0.29, 0.99 } } })
        hl.curve("overshot", { type = "bezier", points = { { 0.13, 0.99 }, { 0.29, 1.1 } } })
        hl.curve("md3_decel", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })
        hl.animation({
          leaf = "windows",
          enabled = true,
          speed = 1,
          bezier = "pace",
          style = "slide",
        })
        hl.animation({
          leaf = "fade",
          enabled = false,
          speed = 3,
          bezier = "default",
        })
        hl.animation({
          leaf = "workspaces",
          enabled = true,
          speed = 3,
          bezier = "default",
        })
        hl.animation({
          leaf = "specialWorkspace",
          enabled = true,
          speed = 1,
          bezier = "default",
          style = "fade",
        })
        hl.animation({
          leaf = "layers",
          enabled = false,
          speed = 1,
          bezier = "default",
        })

        hl.bind("SUPER + Q", hl.dsp.window.close())
        hl.bind("SUPER + SHIFT + Q", hl.dsp.window.kill())
        hl.bind("SUPER + ALT + g", hl.dsp.group.toggle())
        -- TODO: manual review on line 82 — changegroupactive: expected 'f', 'b', or an index (got "")
        -- hl.bind("SUPER + g", hl.dsp.changegroupactive())
        hl.bind("SUPER + m", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
        hl.bind("SUPER + ALT + f", hl.dsp.window.float({ action = "toggle" }))
        hl.bind("SUPER + p", hl.dsp.window.pin())
        hl.bind("SUPER + s", hl.dsp.workspace.toggle_special("social"))
        hl.bind("SUPER + o", hl.dsp.workspace.toggle_special("obsidian"))
        hl.bind("SUPER + y", hl.dsp.workspace.toggle_special("email"))
        hl.bind("SUPER + ALT + d", hl.dsp.window.move({ monitor = "+1" }))
        hl.bind("SUPER + ALT + y", hl.dsp.exec_cmd("nu ${./toggle_dark.nu}"))
        hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("kitty /home/septias/coding"))
        hl.bind("SUPER + i", hl.dsp.exec_cmd("${screenshot}"))
        hl.bind("SUPER + l", hl.dsp.exec_cmd("hyprlock"))
        hl.bind("SUPER + l", hl.dsp.exec_cmd("${pkgs.playerctl} pause"))
        hl.bind("SUPER + ALT + p", hl.dsp.exec_cmd("${pkgs.hyprpicker}/bin/hyprpicker | wl-copy"))
        hl.bind("SUPER + SHIFT + s", hl.dsp.exec_cmd("google-chrome-stable"))
        hl.bind("SUPER + space", hl.dsp.exec_cmd("anyrun"))
        hl.bind("SUPER + e", hl.dsp.exec_cmd("nautilus"))
        hl.bind("SUPER + c", hl.dsp.exec_cmd("xdg-open https://chatgpt.com"))
        hl.bind("SUPER + v", hl.dsp.exec_cmd("xdg-open https://www.wetter.com/deutschland/freiburg-im-breisgau/DE0003016.html"))
        hl.bind("SUPER + b", hl.dsp.focus({ window = "class:google-chrome" }))
        hl.bind("SUPER + r", hl.dsp.focus({ workspace = -1 }))
        hl.bind("SUPER + t", hl.dsp.focus({ workspace = "+1" }))
        hl.bind("SUPER + n", hl.dsp.window.cycle_next({ next = true }))
        hl.bind("SUPER + d", hl.dsp.focus({ monitor = "+1" }))
        hl.bind("SUPER + SHIFT + d", hl.dsp.exec_cmd("nu ${./sort_workspaces.nu}"))
        hl.bind("SUPER + z", hl.dsp.focus({ last = true }))
        hl.bind("SUPER + ALT + t", hl.dsp.window.move({ workspace = "+1" }))
        hl.bind("SUPER + ALT + r", hl.dsp.window.move({ workspace = -1 }))
        hl.bind("SUPER + ALT + b", function() local w = hl.get_active_window(); if not w then return end; hl.dispatch(hl.dsp.window.resize({ x = math.floor(w.size.x * -10 / 100), y = 0, relative = true })) end)
        hl.bind("SUPER + ALT + m", function() local w = hl.get_active_window(); if not w then return end; hl.dispatch(hl.dsp.window.resize({ x = math.floor(w.size.x * 10 / 100), y = 0, relative = true })) end)
        hl.bind("SUPER + SHIFT + o", hl.dsp.window.move({ workspace = "special:obsidian, class:^(obsidian)$" }))
        hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("${pkgs.brightnessctl} set +10%"), { locked = true, repeating = true })
        hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("${pkgs.brightnessctl} set 10%-"), { locked = true, repeating = true })
        hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("${pkgs.pamixer} -i 5"), { locked = true, repeating = true })
        hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("${pkgs.pamixer} -d 5"), { locked = true, repeating = true })
        hl.bind("XF86AudioMute", hl.dsp.exec_cmd("${pkgs.pamixer} -t"), { locked = true, repeating = true })
        hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("${pkgs.playerctl} play-pause"), { locked = true, repeating = true })
        hl.bind("XF86AudioPause", hl.dsp.exec_cmd("${pkgs.playerctl} play-pause"), { locked = true, repeating = true })
        hl.bind("XF86AudioNext", hl.dsp.exec_cmd("${pkgs.playerctl} next"), { locked = true, repeating = true })
        hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("${pkgs.playerctl} prev"), { locked = true, repeating = true })
        hl.bind("SUPER + ALT + n", hl.dsp.exec_cmd("${pkgs.playerctl} next"), { locked = true, repeating = true })
        hl.bind("SUPER + ALT + s", hl.dsp.exec_cmd("${pkgs.playerctl} play-pause"), { locked = true, repeating = true })
        hl.bind("ALT + mouse:272", hl.dsp.window.drag())
        hl.bind("ALT + mouse:273", hl.dsp.window.resize())
        hl.gesture({
          fingers = 3,
          direction = "horizontal",
          action = "workspace",
        })
        hl.monitor({
          output = "DP-5",
          mode = "1920x1080@144.00",
          position = "auto-right",
          scale = "1",
        })

        hl.monitor({
          output = "",
          mode = "preferred",
          position = "auto-right",
          scale = "1",
        })

        hl.window_rule({
          match = {
              class = "sioyek$",
          },
          float = false,
        })

        hl.window_rule({
          match = {
              class = "cs2$",
          },
          immediate = true,
          fullscreen = true,
          workspace = "cs2",
        })

        hl.window_rule({
          match = {
              class = "steam_app_813780",
          },
          immediate = true,
          workspace = "aoe",
        })

        hl.window_rule({
          match = {
              title = "Age of Empires",
          },
          immediate = true,
          workspace = "aoe",
        })

        hl.window_rule({
          match = {
              title = "Age of Empires*",
          },
          immediate = true,
          workspace = "aoe",
        })

        hl.window_rule({
          match = {
              class = "org.telegram.desktop|signal|discord",
          },
          workspace = "special:social",
        })

        hl.window_rule({
          match = {
              title = "^(WhatsApp Web)$",
          },
          workspace = "special:social",
        })

        hl.window_rule({
          match = {
              title = "^(Delta Chat)$",
          },
          workspace = "special:social",
        })

        hl.window_rule({
          match = {
              class = "^(obsidian)$",
          },
          workspace = "special:obsidian",
        })

        hl.window_rule({
          match = {
              title = "^(Mozilla Thunderbird)$",
          },
          workspace = "special:email",
        })

        hl.window_rule({
          match = {
              title = "^(Calendar Reminders)$",
          },
          float = true,
          pin = true,
          size = "800 400",
          move = "((monitor_w/2)) ((monitor_h/2))",
        })

        hl.window_rule({
          match = {
              title = "^(jurts)$",
          },
          float = true,
          pin = true,
          size = "800 400",
          move = "((monitor_w/2)) ((monitor_h/2))",
        })

        hl.workspace_rule({
          workspace = "special:social",
          layout = "scrolling",
        })

        hl.workspace_rule({
          workspace = "w[tv1]",
          gaps_out = 0,
          gaps_in = 0,
        })

        hl.workspace_rule({
          workspace = "f[1]",
          gaps_out = 0,
          gaps_in = 0,
        })

        hl.config({
          animations = {
              enabled = true,
          },
          binds = {
              hide_special_on_workspace_change = true,
          },
          debug = {
              damage_tracking = 2,
              disable_logs = false,
          },
          decoration = {
              dim_inactive = true,
              dim_strength = 0.200000,
              rounding = 5,
          },
          general = {
              allow_tearing = true,
              border_size = 0,
              gaps_in = 5,
              gaps_out = 10,
              layout = "dwindle",
          },
          gestures = {
              workspace_swipe_forever = true,
              workspace_swipe_touch = true,
          },
          group = {
              groupbar = {
                  col = {
                      active = "rgb(51576d)",
                      inactive = "rgb(626880)",
                  },
                  enabled = true,
                  rounding = 5,
              },
              auto_group = true,
          },
          input = {
              touchpad = {
                  disable_while_typing = true,
                  natural_scroll = 1,
              },
              accel_profile = "flat",
              follow_mouse = 1,
              kb_layout = "de,us",
              kb_options = "terminate:ctrl_alt_bksp",
              kb_variant = "neo,",
              repeat_delay = 220,
              repeat_rate = 45,
              sensitivity = 1.300000,
          },
          misc = {
              animate_manual_resizes = true,
              animate_mouse_windowdragging = true,
              font_family = "JetBrainsMono Nerd Font",
              key_press_enables_dpms = true,
              mouse_move_enables_dpms = true,
              vrr = 0,
          },
          render = {
              direct_scanout = 2,
          },
        })

        hl.on("hyprland.start", function()
          hl.exec_cmd("${autostart}/bin/autostart")
          hl.exec_cmd("obsidian", { workspace = "special obsidian silent" })
          hl.exec_cmd("thunderbird", { workspace = "special email silent" })
      end)
    '';
  };
}
