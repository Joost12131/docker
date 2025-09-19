#!/bin/bash

# Script pour configurer SFTP sur un serveur Ubuntu

echo "Vérification du statut SSH..."

# Vérifier si OpenSSH est installé
if ! dpkg -l | grep openssh-server; then
    echo "OpenSSH Server n'est pas installé. Installation..."
    sudo apt update
    sudo apt install -y openssh-server
else
    echo "OpenSSH est déjà installé."
fi

# Vérifier si SSH est activé
if systemctl is-active --quiet ssh; then
    echo "SSH est déjà activé."
else
    echo "Démarrage du service SSH..."
    sudo systemctl enable ssh
    sudo systemctl start ssh
fi

# Vérifier si le port SSH est ouvert dans le firewall
if sudo ufw status | grep -q "22"; then
    echo "Le port 22 (SSH) est déjà autorisé dans le firewall."
else
    echo "Autorisation du port 22 pour SSH..."
    sudo ufw allow 22
    sudo ufw reload
fi

# Vérifier l'adresse IP de l'interface
echo "Vérification de l'adresse IP du serveur..."
ip a | grep -A 2 'eth0'

echo "SFTP est maintenant configuré. Tu peux te connecter en utilisant la commande suivante depuis ton ordinateur :"
echo "sftp user@<IP_PUBLIC_OR_LOCAL>"
