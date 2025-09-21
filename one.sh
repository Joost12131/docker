#!/bin/bash

# Définir les chemins de configuration
PLEX_CONFIG_PATH="$HOME/docker/plex/config"
MEDIA_PATH="$HOME/docker/media"
RADARR_CONFIG_PATH="$HOME/docker/radarr/config"
LIDARR_CONFIG_PATH="$HOME/docker/lidarr/config"
PROWLARR_CONFIG_PATH="$HOME/docker/prowlarr/config"
OVERSEER_CONFIG_PATH="$HOME/docker/overseer/config"
QBITTORRENT_CONFIG_PATH="$HOME/docker/qbittorrent/config"
DOWNLOADS_PATH="$HOME/docker/downloads"

# Créer les répertoires nécessaires
mkdir -p $PLEX_CONFIG_PATH $MEDIA_PATH $RADARR_CONFIG_PATH $LIDARR_CONFIG_PATH $PROWLARR_CONFIG_PATH $OVERSEER_CONFIG_PATH $QBITTORRENT_CONFIG_PATH $DOWNLOADS_PATH

# Créer le fichier docker-compose.yml
cat <<EOL > ~/docker-plex-automation/docker-compose.yml
version: '3.8'

services:
  plex:
    container_name: plex
    image: plexinc/pms-docker
    network_mode: host
    environment:
      - PLEX_UID=1000
      - PLEX_GID=1000
      - VERSION=docker
    volumes:
      - $PLEX_CONFIG_PATH:/config
      - $MEDIA_PATH:/data
    restart: unless-stopped

  radarr:
    container_name: radarr
    image: ghcr.io/linuxserver/radarr
    environment:
      - PUID=1000
      - PGID=1000
    volumes:
      - $RADARR_CONFIG_PATH:/config
      - $MEDIA_PATH:/data
    ports:
      - "7878:7878"
    restart: unless-stopped

  lidarr:
    container_name: lidarr
    image: ghcr.io/linuxserver/lidarr
    environment:
      - PUID=1000
      - PGID=1000
    volumes:
      - $LIDARR_CONFIG_PATH:/config
      - $MEDIA_PATH:/music
    ports:
      - "8686:8686"
    restart: unless-stopped

  prowlarr:
    container_name: prowlarr
    image: ghcr.io/linuxserver/prowlarr
    environment:
      - PUID=1000
      - PGID=1000
    volumes:
      - $PROWLARR_CONFIG_PATH:/config
    ports:
      - "9696:9696"
    restart: unless-stopped

  overseer:
    container_name: overseer
    image: ghcr.io/sct/overseerr
    environment:
      - PUID=1000
      - PGID=1000
    volumes:
      - $OVERSEER_CONFIG_PATH:/config
    ports:
      - "5055:5055"
    restart: unless-stopped

  qbittorrent:
    container_name: qbittorrent
    image: linuxserver/qbittorrent
    environment:
      - PUID=1000
      - PGID=1000
    volumes:
      - $QBITTORRENT_CONFIG_PATH:/config
      - $DOWNLOADS_PATH:/downloads
    ports:
      - "8080:8080"
      - "6881:6881"
    restart: unless-stopped
EOL

# Démarrer les containers avec Docker Compose
cd ~/docker-plex-automation
docker-compose up -d

echo "Installation terminée ! Tout est configuré et les containers sont en cours d'exécution."
