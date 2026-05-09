{ config, pkgs, ... }:

{
  virtualisation.oci-containers = {
    backend = "docker";
    containers."mc" = {
      image = "itzg/minecraft-server:latest";
      autoStart = true;
      extraOptions = [ "--tty" ];

      ports = [
        "25565:25565"
      ];

      environment = {
        EULA = "TRUE";
        VERSION = "26.1.2";
        TYPE = "FABRIC";
        MEMORY = "4G";
        MAX_PLAYERS = "5";
        MOTD = "sex craft";
        USE_MEOWICE_FLAGS = "true";
        DIFFICULTY = "0";
        OPS = "HekkyVR,mtfe";
        ENABLE_WHITELIST = "true";
        WHITELIST = "HekkyVR,mtfe";
        
        SEED = "-5828909824847110575";
      };

      volumes = [
        "/mnt/storage/minecraft:/data"
      ];
    };
  };
  networking.firewall.allowedTCPPorts = [ 25565 ];
}