{ pkgs, ... }:
{
  channel = "stable-25.05";

  packages = [
    pkgs.git
    pkgs.jdk21
    pkgs.coreutils
    pkgs.curl
    pkgs.unzip
  ];

  bootstrap = ''
    echo "Setting up Flutter environment..."

    FLUTTER_HOME=$HOME/flutter

    # Clone Flutter if it doesn't exist
    if [ ! -d "$FLUTTER_HOME" ]; then
      echo "Flutter not found at $FLUTTER_HOME. Cloning stable Flutter SDK..."
      git clone https://github.com/flutter/flutter.git -b stable "$FLUTTER_HOME"
    else
      echo "Flutter already exists at $FLUTTER_HOME"
    fi

    # Add Flutter and pub-cache to PATH
    export PATH=$FLUTTER_HOME/bin:$HOME/.pub-cache/bin:$PATH

    # Verify Flutter
    if ! command -v flutter >/dev/null 2>&1; then
      echo "❌ Flutter binary still not found in $FLUTTER_HOME/bin"
      exit 1
    fi

    echo "Flutter path being used:"
    command -v flutter
    flutter --version

    # Create new Flutter project
    echo "Creating Flutter project..."
    flutter create "$out" --platforms=android,web

    # Setup .idx folder
    mkdir -p "$out/.idx"
    cp ${./dev.nix} "$out/.idx/dev.nix"
    chmod -R u+w "$out"

    echo "✅ Flutter template setup complete!"
    echo "📱 Your Flutter project is ready for development"
  '';
}
