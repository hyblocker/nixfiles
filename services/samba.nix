{ config, pkgs, lib, ... }:

{
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;

    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "NixOS-Storage";
        "netbios name" = "nixos";
        "log level" = 1;
        "logging" = "systemd";
        "socket options" = "TCP_NODELAY IPTOS_LOWDELAY";
        "use sendfile" = true;
        
        # auth / encryption
        "server min protocol" = "SMB3";
        "server max protocol" = "SMB3";
        "encrypt passwords" = true;
        "smb encrypt" = "auto";
        "client signing" = "mandatory";
        "server signing" = "auto";
        "restrict anonymous" = "2";
        "guest account" = "nobody";
      };
      # 10TB hdd. eventually should move to a raid setup for redundancy but thats expensive
      "chudstore" = {
        "path" = "/mnt/storage";
          "read only" = false;
          "force create mode" = "0660";
          "force directory mode" = "2770";
          "force user" = "lux";
          "force group" = "users";
      };
    };
  };

  # for windows discovery
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

}