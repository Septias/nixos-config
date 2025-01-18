{...}: {
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;
      preload = ["~/coding/nixos-config/home-manager/mask.jpeg"];
      wallpaper = ", ~/coding/nixos-config/home-manager/mask.jpeg";
    };
  };
}
