#!/bin/bash

# Variables pour les répertoires de données
SONARR_DIR="/home/vhqzx/sonarr"
RADARR_DIR="/home/vhqzx/radarr"
LIDARR_DIR="/home/vhqzx/lidarr"
PROWLARR_DIR="/home/vhqzx/prowlarr"
OVERSEER_DIR="/home/vhqzx/overseer"
QBITTORRENT_DIR="/home/vhqzx/qbittorrent"
DOWNLOADS_DIR="/home/vhqzx/downloads"
TV_DIR="/home/vhqzx/tv"

# Fonction pour installer Docker si ce n'est pas déjà fait
install_docker() {
    if ! command -v docker &> /dev/null; then
        echo "Docker non trouvé, installation de Docker..."
        
        # Mise à jour des paquets
        sudo apt update && sudo apt upgrade -y

        # Installation des dépendances
        sudo apt install -y ca-certificates curl gnupg lsb-release

        # Ajout du dépôt Docker
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        # Mise à jour des paquets et installation de Docker
        sudo apt update
        sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

        # Démarrage et activation de Docker
        sudo systemctl start docker
        sudo systemctl enable docker
    else
        echo "Docker est déjà installé."
    fi
}

# Fonction pour installer Portainer
install_portainer() {
    echo "Installation de Portainer..."

    sudo docker volume create portainer_data
    sudo docker run -d -p 9000:9000 --name portainer --restart always \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v portainer_data:/data \
        portainer/portainer-ce
}

# Fonction pour installer Sonarr
install_sonarr() {
    echo "Installation de Sonarr..."

    sudo docker run -d \
        --name=sonarr \
        -e PUID=1000 -e PGID=1000 \
        -p 8989:8989 \
        -v $SONARR_DIR/config:/config \
        -v $TV_DIR:/tv \
        -v $DOWNLOADS_DIR:/downloads \
        --restart unless-stopped \
        linuxserver/sonarr
}

# Fonction pour installer Radarr
install_radarr() {
    echo "Installation de Radarr..."

    sudo docker run -d \
        --name=radarr \
        -e PUID=1000 -e PGID=1000 \
        -p 7878:7878 \
        -v $RADARR_DIR/config:/config \
        -v $TV_DIR:/tv \
        -v $DOWNLOADS_DIR:/downloads \
        --restart unless-stopped \
        linuxserver/radarr
}

# Fonction pour installer Lidarr
install_lidarr() {
    echo "Installation de Lidarr..."

    sudo docker run -d \
        --name=lidarr \
        -e PUID=1000 -e PGID=1000 \
        -p 8686:8686 \
        -v $LIDARR_DIR/config:/config \
        -v $DOWNLOADS_DIR:/downloads \
        --restart unless-stopped \
        linuxserver/lidarr
}

# Fonction pour installer Prowlarr
install_prowlarr() {
    echo "Installation de Prowlarr..."

    sudo docker run -d \
        --name=prowlarr \
        -e PUID=1000 -e PGID=1000 \
        -p 9696:9696 \
        -v $PROWLARR_DIR/config:/config \
        -v $DOWNLOADS_DIR:/downloads \
        --restart unless-stopped \
        linuxserver/prowlarr
}

# Fonction pour installer Overseer
install_overseer() {
    echo "Installation de Overseer..."

    sudo docker run -d \
        --name=overseer \
        -e PUID=1000 -e PGID=1000 \
        -p 5055:5055 \
        -v $OVERSEER_DIR/config:/config \
        --restart unless-stopped \
        linuxserver/overseer
}

# Fonction pour installer qBittorrent
install_qbittorrent() {
    echo "Installation de qBittorrent..."

    sudo docker run -d \
        --name=qbittorrent \
        -e PUID=1000 -e PGID=1000 \
        -p 8080:8080 \
        -v $QBITTORRENT_DIR/config:/config \
        -v $DOWNLOADS_DIR:/downloads \
        --restart unless-stopped \
        linuxserver/qbittorrent
}

# Fonction pour installer Plex Media Server
install_plex() {
    echo "Installation de Plex Media Server..."

    # Télécharger le package Plex pour Ubuntu
    wget https://downloads.plex.tv/plex-media-server-new/1.29.1.6549-03f59d64d/debian/plexmediaserver_1.29.1.6549-03f59d64d_amd64.deb

    # Installer le package Plex
    sudo dpkg -i plexmediaserver_1.29.1.6549-03f59d64d_amd64.deb

    # Installer les dépendances manquantes
    sudo apt-get install -f

    # Démarrer Plex
    sudo systemctl start plexmediaserver
    sudo systemctl enable plexmediaserver
}

# Fonction pour vérifier que tout fonctionne
check_status() {
    echo "Vérification de l'état des conteneurs Docker..."

    sudo docker ps
    echo "Plex Media Server doit être accessible à : http://<ton-ip>:32400/web"
}

# Main
install_docker
install_portainer
install_sonarr
install_radarr
install_lidarr
install_prowlarr
install_overseer
install_qbittorrent
install_plex
check_status

echo "Tout est installé ! Tous les services devraient être en cours d'exécution."
