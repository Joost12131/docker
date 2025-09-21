#!/bin/bash

# Variables
MOUNT_POINT="/mnt/plex"
MOVIE_FOLDER="$MOUNT_POINT/Movies"
PARTITION="/dev/sdc2"

# Vérifier si la partition existe
if [ ! -b "$PARTITION" ]; then
    echo "La partition $PARTITION n'existe pas !"
    exit 1
fi

# Vérifier le système de fichiers
echo "Vérification du système de fichiers de $PARTITION..."
FILE_SYSTEM=$(sudo blkid -o value -s TYPE $PARTITION)

# Si le système de fichiers est NTFS, utiliser ntfs-3g pour le montage
if [ "$FILE_SYSTEM" == "ntfs" ]; then
    echo "Système de fichiers NTFS détecté. Installation de ntfs-3g si nécessaire..."
    sudo apt update
    sudo apt install -y ntfs-3g
    MOUNT_CMD="sudo mount -t ntfs-3g"
elif [ "$FILE_SYSTEM" == "ext4" ]; then
    echo "Système de fichiers ext4 détecté."
    MOUNT_CMD="sudo mount -t ext4"
else
    echo "Système de fichiers $FILE_SYSTEM non supporté !"
    exit 1
fi

# Créer le point de montage
echo "Création du répertoire de montage $MOUNT_POINT..."
sudo mkdir -p $MOUNT_POINT

# Monter la partition
echo "Montage de la partition $PARTITION sur $MOUNT_POINT..."
$MOUNT_CMD $PARTITION $MOUNT_POINT

# Créer le répertoire Movies
echo "Création du répertoire Movies..."
sudo mkdir -p $MOVIE_FOLDER

# Changer les permissions pour Radarr
echo "Changement des permissions pour Radarr..."
sudo chown -R radarr:radarr $MOUNT_POINT

# Vérifier que le montage a réussi
echo "Vérification du montage..."
df -h | grep $MOUNT_POINT

# Ajouter l'entrée à /etc/fstab pour un montage automatique au démarrage
echo "Ajout de l'entrée dans /etc/fstab..."
echo "$PARTITION    $MOUNT_POINT    $FILE_SYSTEM    defaults    0    2" | sudo tee -a /etc/fstab > /dev/null

# Tester si le montage automatique fonctionne
echo "Test du montage automatique..."
sudo mount -a

# Afficher la confirmation
echo "Tout est configuré ! La partition $PARTITION est montée sur $MOUNT_POINT et configurée pour un montage automatique au démarrage."

