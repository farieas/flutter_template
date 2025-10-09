{ pkgs, ... }:
{
  channel = "stable-25.05";

  packages = [
    pkgs.git
    pkgs.jdk21
    pkgs.coreutils      # for basic shell commands like mkdir, chmod, command
    pkgs.makeWrapper    # needed to wrap flutter binary
  ];

  bootstrap = ''
    echo "Setting up local Flutter SDK inside Nix shell..."

    # Path to your local Flutter
    FLUTTER_HOME=$HOME/flutter
    export PATH=$FLUTTER_HOME/bin:$HOME/.pub-cache/bin:$PATH

    # Wrap flutter to make it accessible in Nix environment
    if [ ! -f "$FLUTTER_HOME/bin/flutter_wrapped" ]; then
      echo "Wrapping Flutter binary..."
      ${pkgs.makeWrapper}/bin/makeWrapper $FLUTTER_HOME/bin/flutter $FLUTTER_HOME/bin/flutter_wrapped \
        --prefix PATH : "$FLUTTER_HOME/bin"
    fi

    # Use the wrapped binary
    export PATH=$FLUTTER_HOME/bin:$PATH

    # Verify Flutter
    echo "Flutter path being used:"
    command -v flutter_wrapped
    flutter_wrapped --version

    # Create new Flutter project with static name
    echo "Creating Flutter project..."
    flutter_wrapped create "$out" --platforms=android,web

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
