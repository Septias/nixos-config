{
  inputs,
  pkgs,
  ...
}: {
  programs.anyrun = {
    enable = true;
    config = {
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        (pkgs.callPackage ./gh {})
        applications
        websearch
      ];
      width.fraction = 0.3;
      hidePluginInfo = true;
      closeOnClick = true;
      y.absolute = 100;
    };

    extraCss = ''
      @define-color bg-col  rgba(30, 30, 46, 0.7);
      @define-color border-col #e78284;
      @define-color fg-col #D9E0EE;

      * {
        transition: 110ms ease;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 1.3rem;
      }

      #window {
        background: transparent;
      }

      #plugin,
      #main {
        color: @fg-col;
        background-color: transparent;
      }

      /* anyrun's input window - Text */
      #entry {
        padding: 3px 10px;
        color: @fg-col;
        background-color: @bg-col;
        border-color: @border-col;
      }

      /* anyrun's ouput matches entries - Base */
      #match {
        color: @fg-col;
        padding: 3px;
        border-radius: 16px;
        background-color: @bg-col;
      }

      /* anyrun's selected entry */
      #match:selected {
        border-radius: 16px;
        border-color: @border-col;
        color: @fg-col;
      }

      #entry, #plugin:hover {
        border-radius: 16px;
      }
    '';

    extraConfigFiles."websearch.ron".text = ''
      Config(
        prefix: "?",
        engines: [DuckDuckGo]
      )
    '';
  };
}
