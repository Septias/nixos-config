{...} : {programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      auth = {
        "fingerprint:enabled" = true;
      };

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          dots_center = true;
          fade_on_empty = false;
          dots_size = 0.2;
          dots_spacing = 0.6;
          font_color = "rgb(198, 208, 245)";
          inner_color = "rgb(48, 52, 70)";
          outer_color = "rgb(131, 139, 167)";
          check_color = "rgb(48, 52, 70)";
          fail_color = "rgb(231, 130, 132)";
          outline_thickness = 2;
          placeholder_text = "•`_´•";
          shadow_passes = 2;
        }
      ];
    };
  };
}
