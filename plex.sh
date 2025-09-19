#!/bin/bash

# Télécharger Plex Media Server
echo "Téléchargement de Plex Media Server..."
wget -q --show-progress https://downloads.plex.tv/plex-media-server-new/1.29.1.6549-03f59d64d/debian/plexmediaserver_1.29.1.6549-03f59d64d_amd64.deb

# Vérifier si le fichier a été téléchargé
if [ ! -f plexmediaserver_1.29.1.6549-03f59d64d_amd64.deb ]; then
    echo "Erreur : Le fichier Plex Media Server n'a pas été téléchargé correctement."
    exit 1
fi

# Installer Plex Media Server
echo "Installation de Plex Media Server..."
sudo dpkg -i plexmediaserver_1.29.1.6549-03f59d64d_amd64.deb

# Résoudre les dépendances manquantes
echo "Installation des dépendances manquantes..."
sudo apt-get install -f -y

# Vérifier si Plex est installé
if ! dpkg -l | grep -q plexmediaserver; then
    echo "Erreur : L'installation de Plex a échoué."
    exit 1
fi

# Démarrer Plex Media Server
echo "Démarrage de Plex Media Server..."
sudo systemctl start plexmediaserver

# Vérifier si Plex fonctionne
echo "Vérification de l'état de Plex Media Server..."
sudo systemctl status plexmediaserver | grep "active (running)" > /dev/null

if [ $? -eq 0 ]; then
    echo "Plex Media Server est en cours d'exécution."
else
    echo "Erreur : Plex Media Server n'a pas démarré correctement."
    exit 1
fi

# Activer Plex pour démarrer automatiquement au boot
echo "Activation de Plex Media Server au démarrage..."
sudo systemctl enable plexmediaserver

# Afficher l'URL d'accès à Plex
echo "Plex Media Server est maintenant installé et démarré."
echo "Accédez à Plex via : http://<ton-ip>:32400/web"
echo "Remplacez <ton-ip> par l'adresse IP de votre serveur."

# Fin du script
echo "Installation de Plex Media Server terminée."
