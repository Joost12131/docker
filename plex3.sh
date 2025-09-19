#!/bin/bash

# Script d'installation de Plex Media Server sur Ubuntu

# Télécharger le fichier .deb de Plex
echo "Téléchargement de Plex Media Server..."
wget https://downloads.plex.tv/plex-media-server-new/1.42.1.10060-4e8b05daf/debian/plexmediaserver_1.42.1.10060-4e8b05daf_amd64.deb -O plexmediaserver.deb

# Installer Plex Media Server
echo "Installation de Plex Media Server..."
sudo dpkg -i plexmediaserver.deb

# Résoudre les dépendances manquantes si nécessaire
echo "Résolution des dépendances manquantes..."
sudo apt-get install -f -y

# Démarrer le service Plex
echo "Démarrage de Plex Media Server..."
sudo systemctl start plexmediaserver

# Vérifier l'état du service Plex
echo "Vérification du statut de Plex Media Server..."
sudo systemctl status plexmediaserver

# Activer Plex au démarrage du système
echo "Activation de Plex Media Server au démarrage..."
sudo systemctl enable plexmediaserver

# Nettoyage
echo "Nettoyage des fichiers inutiles..."
rm plexmediaserver.deb

echo "Plex Media Server installé avec succès !"
