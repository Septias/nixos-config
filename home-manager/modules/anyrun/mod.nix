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
      @define-color bg-col-light rgba(150, 220, 235, 0.7);
      @define-color border-col rgba(30, 30, 46, 0.7);
      @define-color selected-col rgba(150, 205, 251, 0.7);
      @define-color fg-col #D9E0EE;
      @define-color fg-col2 #F28FAD;

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
        border-color: #e78284;
      }

      /* anyrun's ouput matches entries - Base */
      #match {
        color: @fg-col;
        background-color: @bg-col;
      }

      /* anyrun's selected entry */
      #match:selected {
        color: @fg-col2;
      }

      #match {
        padding: 3px;
        border-radius: 16px;
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
