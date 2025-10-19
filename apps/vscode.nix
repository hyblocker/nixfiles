{
  config,
  pkgs,
  lib,
  ...
}:

{
  home-manager.users.lux =
    { pkgs, ... }:
    {
      programs = {
        vscode = {
          enable = true;

          # https://github.com/continuedev/continue/issues/821#issuecomment-3227673526
          package = (
            pkgs.vscode.overrideAttrs (
              final: prev: {
                preFixup =
                  prev.preFixup
                  + "gappsWrapperArgs+=( --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ pkgs.gcc.cc.lib ]})";
              }
            )
          );

          profiles.default = {
            userSettings = {
              editor.formatOnSave = true;
              editor.cursorSmoothCaretAnimation = true;
              window.autoDetectColorScheme = true;
              terminal.integrated.enableMultiLinePasteWarning = false;
              terminal.integrated.stickyScroll.enabled = false;
              chat.disableAiFeatures = true;
              "nix.enableLanguageServer" = true;
              "C_Cpp.intelliSenseEngine" = "disabled"; # conflicts with clangd, which has better intellisense lol
            };

            extensions = with pkgs.vscode-extensions; [
              eamodio.gitlens
              jnoortheen.nix-ide
              llvm-vs-code-extensions.vscode-clangd
              ms-vscode.cmake-tools
              ms-vscode.cpptools
              ms-vscode.hexeditor
              ms-vscode-remote.remote-ssh
              redhat.vscode-xml
              xaver.clang-format
              yzhang.markdown-all-in-one
            ];
          };
        };
      };
    };
}
