{
  inputs,
  pkgs,
  ...
}: {
  programs.anyrun = {
    enable = true;
    package = pkgs.unstable.anyrun;
    config = {
      plugins = [
        # (pkgs.callPackage ./gh {})
        "${pkgs.unstable.anyrun}/lib/libapplications.so"
        "${pkgs.unstable.anyrun}/lib/libwebsearch.so"
      ];
      width.fraction = 0.3;
      layer = "overlay";
      hidePluginInfo = false;
      closeOnClick = true;
      y.absolute = 100;
    };

    extraCss = ''
      window {
        background: transparent;
      }

      box.main {
        padding: 5px;
        margin: 10px;
        border-radius: 10px;
        border: 2px solid black;
        background-color: #4c4f69;
      }

      text {
        min-height: 30px;
        padding: 5px;
        border-radius: 5px;
      }

      .matches {
        background-color: #4c4f69;
        border-radius: 10px;
      }

      box.plugin:first-child {
        margin-top: 5px;
      }

      box.plugin.info {
        min-width: 200px;
      }

      list.plugin {
        background-color: #4c4f69;
      }

      label.match.description {
        font-size: 10px;
      }

      label.plugin.info {
        font-size: 14px;
      }

      .match {
        background: transparent;
      }

      .match:selected {
        border-left: 4px solid #e64553;
        background: transparent;
        animation: none;
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
