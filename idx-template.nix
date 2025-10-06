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
    flutter create myapp --platforms=android,web
    
    # Copy all files from myapp to output directory
    echo "Setting up project structure..."
    cp -r myapp/* "$out/"
    cp -r myapp/.* "$out/" 2>/dev/null || true
    
    # Clean up temporary directory
    rm -rf myapp
    
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

