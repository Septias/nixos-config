{config, ...}: {
  imports = [./hardware-configuration.nix];

  networking.hostName = "nixos-desktop";

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];
  # in case you have problem with booting to text mode
  boot.initrd.kernelModules = ["nvidia"];
  #boot.extraModulePackages = [config.boot.kernelPackages.nvidia_x11];
  boot.kernelParams = ["nvidia-drm.fbdev=1"];

  hardware.nvidia = {
    forceFullCompositionPipeline = false;

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = true;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = true;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Do not disable this unless your GPU is unsupported or if you have a good reason to.
    open = false;

    # forceFullCompositionPipeline = true;
    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
}
