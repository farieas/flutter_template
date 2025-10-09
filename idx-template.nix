{ pkgs, ... }:
{
  channel = "stable-25.05";

  packages = [
    pkgs.git
    pkgs.jdk21
  ];

  bootstrap = ''
    echo "Using local Flutter SDK from \$HOME/flutter/bin"

    # Add local Flutter and pub-cache to PATH
    export PATH=$HOME/flutter/bin:$PATH
    export PATH=$HOME/.pub-cache/bin:$PATH

    # Debugging: Print PATH to verify
    echo $PATH

    # Verify Flutter
    echo "Flutter path being used:"
    # which flutter
    # flutter --version

    # Create new Flutter project with static name
    echo "Creating Flutter project..."
    flutter create "$out" --platforms=android,web

    # Create .idx directory in the project root
    echo "Setting up IDX environment..."
    mkdir -p "$out/.idx"

    # Copy dev.nix configuration to the project's .idx folder
    cp ${./dev.nix} "$out/.idx/dev.nix"

    # Ensure proper permissions
    chmod -R u+w "$out"

    echo "✅ Flutter template setup complete!"
    echo "📱 Your Flutter project is ready for development"
  '';
}
