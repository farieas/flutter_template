{ pkgs, ... }:

{
  channel = "stable-25.05";

  packages = [
    pkgs.flutter
    pkgs.dart
    pkgs.git
  ];

  bootstrap = ''
    # Create new Flutter project
    flutter create "$out" --platforms=ios,android,web

    # Create .idx config
    mkdir -p .idx
    cp ${./dev.nix} "$out/.idx/dev.nix"
    chmod -R u+w "$out"
    echo "✅ Flutter complete!"

  '';
}
