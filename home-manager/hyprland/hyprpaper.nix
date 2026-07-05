{...}: {
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      wallpaper = [
        {
          monitor = "";
          path = "${../wallpaper.png}";
          fit_mode = "cover";
        }
      ];
    };
  };
}
