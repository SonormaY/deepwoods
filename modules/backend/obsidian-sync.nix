{ config, pkgs, ... }:

{
  systemd.tmpfiles.rules = [
    "d /var/lib/couchdb 0700 1001 1001 -"
  ];

  virtualisation.oci-containers.containers.obsidian-couchdb = {
    image = "docker.io/oleduc/docker-obsidian-livesync-couchdb:latest";
    autoStart = true;

    ports = [
      "127.0.0.1:5984:5984"
    ];

    volumes = [
      "/var/lib/couchdb:/opt/couchdb/data"
      "/var/lib/couchdb/etc:/opt/couchdb/etc/local.d"
    ];

    environmentFiles = [
      config.sops.secrets."couchdb-creds".path
    ];

    environment = {
      COUCHDB_USER = "sonorma";
      COUCHDB_DATABASE = "obsidian_vault";
      NODENAME = "couchdb@127.0.0.1";
    };
  };
}
