{
  pkgs,
  lib,
  ...
}: {
  home.packages = [
    (pkgs.emacsWithPackagesFromUsePackage {
      # package = pkgs.emacs-git; # replace with pkgs.emacsPgtk, or another version if desired.
    # config = "${pkgs.fetchFromGitHub {
    #   owner = "syl20bnr";
    #   repo = "spacemacs";
    #   rev = "9542f41";
    #   hash = "sha256-IqlnL9ItAima24Er9VS0Rrgopx+GO4akORKlPYEAkyM=";
    # }}/init.el";
    config = ./emacs.el;

      # Optionally provide extra packages not in the configuration file.
      extraEmacsPackages = epkgs:
        with epkgs; [
          # magit
          # avy
          # meow
        ];
      defaultInitFile = true;

      # override = epkgs:
      #   epkgs
      #   // {
      #     isar-mode = pkgs.unstable.emacs.pkgs.melpaBuild {
      #       pname = "isar-mode";
      #       version = "0.1";
      #       src = pkgs.fetchFromGitHub {
      #         owner = "m-fleury";
      #         repo = "isar-mode";
      #         rev = "354b881";
      #         hash = "sha256-CTZsPqZjaUiGLw8hJiAK8MFCvNSJVS1JN5ZSMPo6vmQ=";
      #       };
      #     };

      #     lsp-isar = pkgs.unstable.emacs.pkgs.melpaBuild {
      #       pname = "lsp-isar";
      #       version = "0.0";
      #       src = pkgs.fetchFromGitHub {
      #         owner = "m-fleury";
      #         repo = "isabelle-emacs";
      #         rev = "76112b8a114eb7405d618ccc0630d14fb22621e1";
      #         hash = "sha256-pKB3YyA7CGOgpAs7OKqfcAa9v/Ql5xC4K90waa0aTFk=";
      #       };
      #       files = "(\"src/Tools/emacs-lsp/lsp-isar/*.el\")";
      #     };
      #   };
    })
  ];
}
