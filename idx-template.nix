{ pkgs, ... }:
{
  channel = "stable-25.05";

  packages = [
    pkgs.flutter
    pkgs.git
    pkgs.jdk21
  ];

  bootstrap = ''
    # Create new Flutter project with static name
    echo "Creating Flutter project..."
    flutter create my_app --platforms=android,web
    
    # Move the contents of my_app to the output directory
    cp -r my_app/* "$out/"
    cp -r my_app/.* "$out/" 2>/dev/null || true
    rm -rf my_app
    
    
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

