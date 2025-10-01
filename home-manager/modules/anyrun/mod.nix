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
        "${pkgs.unstable.anyrun}/lib/libtranslate.so"
        "${pkgs.unstable.anyrun}/lib/libsymbols.so"
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
        border: 2px solid #232634;
        color: #c6d0f5;
        background-color: #303446;
      }


      text {
        min-height: 30px;
        padding: 5px;
        border-radius: 5px;
        color: #c6d0f5;
      }

      .matches {
        background-color: #414559;
        border-radius: 10px;
      }

      box.plugin:first-child {
        margin-top: 5px;
      }

      box.plugin.info {
        min-width: 200px;
      }

      list.plugin {
        background-color: #414559;
      }

      label.match.description {
        font-size: 10px;
      }

      label.plugin.info {
        font-size: 14px;
      }

      .match {
        background: transparent;
        color: #c6d0f5;
      }

      .match:selected {
        border-left: 2px solid #ef9f76;
        background-color: #303446;
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
