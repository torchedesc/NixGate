# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  # To get the Coral stuff to build get:
  # https://github.com/colino17/nixdots/blob/6291ecdccc3670c8e823b8e5f1fd5c0bb1a2993c/services/coral.nix
  # https://github.com/colino17/nixdots/blob/main/packages/gasket.nix
  # https://github.com/colino17/nixdots/blob/main/packages/libedgetpu.nix

  # Put coral.nix in /etc/nixos/ put gasket.nix and libedgetpu.nix in /etc/nixos/packages
  # Import ./coral.nix

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./coral.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.kernelParams = ["intel_iommu=on"];
  boot.loader.efi.canTouchEfiVariables = true;

  # HostName
  networking.hostName = "frigate"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.USER = {
    isNormalUser = true;
    description = "USER";
    extraGroups = [ "networkmanager" "wheel" "docker" "apex" ]; # apex is needed for the TPU.
    packages = with pkgs; [
       tree
       nano
       htop
       tailscale
       zfs
       btop
       pciutils
       usbutils
       tmux
       ncdu
    ];
  };

  # Enable Docker
  virtualisation.docker = {
    enable = true;
  };
 
  # Fish Shell
  programs.fish.enable = true;

  # Enables the tailscale service
  services.tailscale.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    curl
    nano
    git
    wget
    python3
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
