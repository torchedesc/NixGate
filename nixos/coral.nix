{ config, pkgs, ... }:

let 
  libedgetpu = config.boot.kernelPackages.callPackage /etc/nixos/packages/libedgetpu.nix {}; 
  gasket = config.boot.kernelPackages.callPackage /etc/nixos/packages/gasket.nix {};
in
{
  services.udev.packages = [ libedgetpu ];                                                                                                                                                                                              
  users.groups.plugdev = {};  
  boot.extraModulePackages = [ gasket ];
}
