{ pkgs, ... }:
{
  channel = "stable-25.05";

  packages = [
    pkgs.flutter
    pkgs.dart
    pkgs.git
    pkgs.unzip
    pkgs.jdk21
  ];

  bootstrap = ''
    # Create new Flutter project with static name
    echo "Creating Flutter project..."
    flutter create myapp --platforms=android,web
    
    # Move the created project to the output directory
    echo "Setting up project structure..."
    mv myapp/* "$out/"
    mv myapp/.* "$out/" 2>/dev/null || true
    rmdir myapp
    
    # Create .idx directory in the project root
    mkdir -p "$out/.idx"
    
    # Copy dev.nix configuration to the project's .idx folder
    echo "Setting up IDX environment..."
    cp ${./dev.nix} "$out/.idx/dev.nix"
    
    # Ensure proper permissions
    chmod -R u+w "$out"
    
    echo "✅ Flutter template setup complete!"
    echo "📱 Your Flutter project is ready for development"
  '';
}
