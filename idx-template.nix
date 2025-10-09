{ pkgs, ... }:
{
  channel = "stable-25.05";

  packages = [
    pkgs.git
    pkgs.jdk21
    pkgs.coreutils  # basic shell commands
  ];

  bootstrap = ''
    echo "Setting up local Flutter SDK..."

    # Prepend local Flutter and pub-cache to PATH
    export PATH=$HOME/flutter/bin:$HOME/.pub-cache/bin:$PATH

    # Check if Flutter exists
    if ! command -v flutter >/dev/null 2>&1; then
      echo "❌ Error: Flutter binary not found in \$HOME/flutter/bin"
      echo "Please install Flutter locally or adjust the PATH."
      exit 1
    fi

    # Verify Flutter
    echo "Flutter path being used:"
    command -v flutter
    flutter --version

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
