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
    
    # Create the output directory if it doesn't exist
    mv "myapp" "$out"
    
    # Move the created project to the output directory
    echo "Setting up project structure..."
    
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

