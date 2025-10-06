{ pkgs, ... }:
{
  channel = "stable-24.05";

  packages = [
    pkgs.flutter
    pkgs.dart
    pkgs.git
    pkgs.unzip
    pkgs.jdk21
  ];

  bootstrap = ''
    # Create new Flutter project
    echo "Creating Flutter project..."
    flutter create "$out" --platforms=ios,android,web
    
    # Create .idx directory if it doesn't exist
    mkdir -p "$out/.idx"

    # Ensure proper permissions
    chmod -R u+w "$out"
    
    # Copy dev.nix configuration
    echo "Setting up IDX environment..."
    cp ${./dev.nix} "$out/.idx/dev.nix"
    
    # Ensure proper permissions
    chmod -R u+w "$out"
    
    echo "✅ Flutter template setup complete!"
    echo "📱 Your Flutter project is ready for development"
  '';
}
