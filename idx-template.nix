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
    flutter create "out/my_app" --platforms=android,web
    
    # Create .idx directory in the project root
    echo "Setting up IDX environment..."
    mkdir -p "out/my_app/.idx"
    
    # Copy dev.nix configuration to the project's .idx folder
    cp ${./dev.nix} "out/my_app/.idx/dev.nix"


    # Ensure proper permissions
    chmod -R u+w "out/my_app"

    echo "✅ Flutter template setup complete!"
    echo "📱 Your Flutter project is ready for development"
  '';
}

