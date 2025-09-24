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
        (pkgs.callPackage ./gh {})
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
        background: red;
      }

      box.main {
        padding: 5px;
        margin: 10px;
        border-radius: 10px;
        border: 2px solid #ef9f76;
        background-color: red;
      }


      text {
        background-color: red;
        min-height: 30px;
        padding: 5px;
        border-radius: 5px;
        border-color: #ef9f74;
      }

      .matches {
        background-color: red;
        border-radius: 10px;
      }

      box.plugin:first-child {
        background-color: red;
        margin-top: 5px;
      }

      box.plugin.info {
        background-color: red;
        min-width: 200px;
      }

      list.plugin {
        background-color: rgba(0, 0, 0, 0);
      }

      label.match.description {
        background-color: red;
        font-size: 10px;
      }

      label.plugin.info {
        background-color: red;
        font-size: 14px;
      }

      .match {
        background-color: red;
      }

      .match:selected {
        border-left: 4px solid #ef9f76;
        background-color: red;
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
