#!/bin/bash

# Mise à jour du système
sudo apt update && sudo apt upgrade -y

# Installation des dépendances nécessaires
sudo apt install -y ca-certificates curl gnupg lsb-release

# Création du dossier pour les clés GPG de Docker
sudo mkdir -p /etc/apt/keyrings

# Ajout de la clé GPG de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Ajout du dépôt Docker
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Mise à jour des paquets
sudo apt update

# Installation de Docker
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Démarrage et activation de Docker au démarrage
sudo systemctl start docker
sudo systemctl enable docker

# Vérification du statut de Docker
sudo systemctl status docker

# Test de Docker avec un container Hello-World
sudo docker run hello-world
