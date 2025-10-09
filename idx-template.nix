{ pkgs, ... }:
{
  channel = "stable-25.05";

  packages = [
    pkgs.git
    pkgs.jdk21
    pkgs.coreutils
    pkgs.curl
    pkgs.unzip
    pkgs.xz 
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

    # Precache Flutter artifacts to ensure Dart SDK and tools are downloaded
    echo "Downloading Flutter artifacts and Dart SDK..."
    flutter precache --web --android --no-ios --no-macos --no-linux --no-windows --no-fuchsia
    
    if [ $? -ne 0 ]; then
      echo "❌ Flutter precache failed. Retrying..."
      flutter precache --web --android --no-ios --no-macos --no-linux --no-windows --no-fuchsia
    fi

    # Run flutter doctor to populate cache and verify installation
    echo "Initializing Flutter SDK..."
    flutter doctor -v

    if [ $? -ne 0 ]; then
      echo "⚠️  Flutter doctor reported issues, but continuing setup..."
    fi

    # Create new Flutter project
    echo "Creating Flutter project..."
    flutter create "$out" --platforms=android,web

    # Setup .idx folder
    echo "Setting up IDX environment..."
    mkdir -p "$out/.idx"
    cp ${./dev.nix} "$out/.idx/dev.nix"

    # Ensure proper permissions
    chmod -R u+w "$out"

    echo "✅ Flutter template setup complete!"
    echo "📱 Your Flutter project is ready for development"
  '';
}
