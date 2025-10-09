{ pkgs, ... }:
{
  channel = "stable-25.05";

  packages = [
    pkgs.git
    pkgs.jdk21
    pkgs.flutter
  ];

  bootstrap = '' 

    flutter create --project-name="my_new_name" .
    
  '';
}
