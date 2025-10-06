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
    flutter create MyAPP --platforms=android,web
    
    # Navigate to the project directory
    cd MyAPP
    
    # Create .idx directory in the project root
    mkdir -p .idx
    
    # Copy dev.nix configuration to the project's .idx folder
    echo "Setting up IDX environment..."
    cp ${./dev.nix} .idx/dev.nix
    
    # Ensure proper permissions
    chmod -R u+w .
    
    echo "✅ Flutter template setup complete!"
    echo "📱 Your Flutter project 'MyAPP' is ready for development"
  '';
}
