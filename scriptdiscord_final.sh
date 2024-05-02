#!/bin/bash

# Définition des variables
TEMPLATE_FILE="/home/gapi/void-packages/srcpkgs/discord/template"
XBPS_SRC_DIR="$HOME/void-packages"

# Fonction pour mettre à jour le fichier template
update_template() {
    sed -i "s/^version=[[:alnum:].-]*/version=$1/g" "$TEMPLATE_FILE"
    echo "La version du paquet Discord a été mise à jour vers $1 dans le fichier template."
}

# Fonction pour exécuter la commande xgensum
execute_xgensum() {
    echo "Exécution de 'xgensum -i discord'..."
    (cd "$XBPS_SRC_DIR/srcpkgs/discord" && xgensum -i discord)
}

# Fonction pour exécuter la commande xbps-src pkg discord
execute_xbps_pkg() {
    echo "Exécution de './xbps-src pkg discord'..."
    (cd "$XBPS_SRC_DIR" && ./xbps-src pkg discord)
}

# Fonction pour installer Discord
install_discord() {
    echo "Installation de Discord..."
    sudo xbps-install -Sy discord
}

# Récupérer la version actuelle depuis le fichier template
CURRENT_VERSION=$(grep "^version=" "$TEMPLATE_FILE" | cut -d= -f2)

# Calculer la version suivante (+0.0.1 par rapport à la version actuelle)
NEXT_VERSION=$(awk -F. '{print $1"."$2"."$3+1}' <<< "$CURRENT_VERSION")

# Proposer un choix multiple à l'utilisateur
echo "Quelle version souhaitez-vous utiliser pour le paquet Discord ?"
echo "1) $CURRENT_VERSION"
echo "2) $NEXT_VERSION"
echo "3) Autre"

read -p "Entrez le numéro correspondant à votre choix : " CHOICE

# Modifier la version en fonction du choix de l'utilisateur
case $CHOICE in
    1)
        NEW_VERSION="$CURRENT_VERSION"
        ;;
    2)
        NEW_VERSION="$NEXT_VERSION"
        ;;
    3)
        read -p "Entrez la nouvelle version du paquet Discord : " NEW_VERSION
        ;;
    *)
        echo "Choix invalide."
        exit 1
        ;;
esac

# Modification de la version dans le fichier template
update_template "$NEW_VERSION"

# Demander à l'utilisateur s'il souhaite exécuter xgensum
read -p "Exécuter xgensum ? (Y/n) " EXECUTE_XGENSUM

# Vérifier si l'utilisateur a choisi d'exécuter xgensum
case ${EXECUTE_XGENSUM,,} in
    y|yes|"")
        execute_xgensum
        ;;
    n|no)
        echo "xgensum n'a pas été exécuté."
        ;;
    *)
        echo "Choix invalide."
        ;;
esac

# Vérifier si une erreur SHA256 mismatch est détectée
if grep -q "ERROR: SHA256 mismatch" "$XBPS_SRC_DIR/srcpkgs/discord/discord-*.log" 2>/dev/null; then
    echo "Une erreur SHA256 mismatch a été détectée."
    read -p "Voulez-vous relancer la dernière commande ? (Y/n) " RELAUNCH_COMMAND
    case ${RELAUNCH_COMMAND,,} in
        y|yes|"")
            echo "Relancement de la dernière commande..."
            bash -c "$(tail -n 1 "$XBPS_SRC_DIR/srcpkgs/discord/discord-*.log" | sed 's/^# //')"
            ;;
        n|no)
            echo "La dernière commande n'a pas été relancée."
            ;;
        *)
            echo "Choix invalide."
            ;;
    esac
fi

# Demander à l'utilisateur s'il souhaite compiler le paquet depuis les sources
read -p "Compiler le paquet depuis les sources ? (Y/n) " COMPILE_FROM_SOURCE

# Vérifier si l'utilisateur a choisi de compiler depuis les sources
case ${COMPILE_FROM_SOURCE,,} in
    y|yes|"")
        execute_xbps_pkg
        ;;
    n|no)
        echo "Le paquet ne sera pas compilé depuis les sources."
        ;;
    *)
        echo "Choix invalide."
        ;;
esac

# Demander à l'utilisateur s'il souhaite installer Discord
read -p "Installer Discord ? (Y/n) " INSTALL_DISCORD

# Vérifier si l'utilisateur a choisi d'installer Discord
case ${INSTALL_DISCORD,,} in
    y|yes|"")
        install_discord
        ;;
    n|no)
        echo "L'installation de Discord n'a pas été effectuée."
        ;;
    *)
        echo "Choix invalide."
        ;;
esac

echo "Discord est à jour."
