# Frigate on NixOS

This is how I use Frigate via Docker Compose in NixOS with a Mini PCI-e Google Coral TPU.
Included is a working simplified NixOS configuration, Docker Compose file, and Frigate configuration file.
The setup assumes a fresh install of NixOS, an intel cpu/igpu, PCI-e based Coral TPU, some basic NixOS linux and docker knowledge. It may also require reading the Frigate documentation to get **your** cameras working.

**References**

1. [Frigate](https://docs.frigate.video/)
2. [Coral TPU](https://coral.ai/docs/m2/get-started#2a-on-linux)
3. [NixOS Wiki](https://nixos.wiki/)


Lets prepare by grabbing the files needed and enter the new directory.

`git clone https://github.com/torchedesc/NixGate.git`

cd into that directory.

### First the NixOS stuff

Even though NixOS has roll backs, we should make a copy of the configuration.nix file for safe keeping. Since this setup assumes a clean install of NixOS we will be copying our own configuration.nix file over the system one later.

`sudo cp /etc/nixos/configuration.nix ~/configuration.nix_BAK`

Next we will make the packages directory in /etc/nixos/ and copy the required files.

```
1. sudo mkdir /etc/nixos/packages/
2. sudo cp ./nixos/coral.nix /etc/nixos/
3. sudo cp ./nixos/gasket.nix /etc/nixos/packages/
4. sudo cp ./nixos/libedgetpu.nix /etc/nixos/packages/
```

We should edit the new configuration.nix file before copying it over. 

`5. nano ./nixos/configuration.nix`

 Change the host name, time zone, and add or remove things you may want aside from what is needed for Frigate. If you want to just copy the Frigate related stuff to your configuration.nix, they are commented in the included configuration.nix file we pulled down.

Once satisfied copy it to /etc/nixos/ .

`6. sudo cp ./nixos/configuration.nix /etc/nixos/`

Now we can rebuild and switch to the new OS which preps the Coral TPU, docker, and user permissions.

`7. sudo nixos-rebuild switch`

Go brew some tea because this may take a while. :)

Once this is complete, reboot the machine so the new user permissions are activated.


### Docker & Frigate

Now that OS is prepped and ready to run docker compose. Here we will get the docker and Frigate stuff setup.
Create the directories for your camera media and docker compose files then copy them over. As defined in this compose.yml example we will be keeping everything in the home directory.
```
mkdir -p ~/docker/frigate/
cp ./docker/compose.yml ~/docker/frigate/
cp ./docker/config.yml ~/docker/frigate/
```

Edit compose.yml to suite your needs.

`nano ~/docker/frigate/compose.yml`

Next edit the config.yml. This file is the heart of Frigate. It has all of your camera information, settings, detection tuneables, etc. I recommend reading through Frigates documentation to see how things work. I used their template for my own setup used in this example.

[Full Reference Config](https://docs.frigate.video/configuration/reference)

`nano ~/docker/frigate/config.yml`

In this file you will need to enter your cameras IP address's as well as their RTSP user name and password, so have them on hand.

The example used will record when a person is detected and take a snap shot when a dog or cat is detected. 

**Assuming there is a PCIe TPU and Intel video encoder the only things we need to change here are the Camera details starting at line 159.** These Settings work with my Riolink RLC-410-5MP cameras. Please refer to Frigate documentation otherwise.

[Camera Configuration](https://docs.frigate.video/configuration/cameras)

**An example of the camera specific lines that need to be changed**
```
go2rtc:
  streams:
    username: bob
    password: SeCuRePaSsWoRd
    frontdoor:
      - rtsp://bob:SeCuRePaSsWoRd@192.168.1.151:554/h264Preview_01_main
    frontdoor_sub:
      - rtsp://bob:SeCuRePaSsWoRd@192.168.1.151:554/h264Preview_01_sub
    driveway:
      - rtsp://bob:SeCuRePaSsWoRd@192.168.1.152:554/h264Preview_01_main
    driveway_sub:
      - rtsp://bob:SeCuRePaSsWoRd@192.168.1.152:554/h264Preview_01_sub
```

### Run the thing!

Last thing left is to run the app and see if things are working.

cd to the docker frigate folder.

`cd ~/docker/frigate/`

Run docker compose to pull and start Frigate

`docker compose up -d`

From here you should be able to navigate to the machines IP address and append port 5000 to get to the Frigate WebUI.

Example: `192.168.1.183:5000`
