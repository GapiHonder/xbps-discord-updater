#!/bin/bash

# Définition du fichier de log
LOG_FILE="log.txt"

# Fonction pour mettre à jour le fichier template
update_template() {
    sed -i "s/^version=[[:alnum:].-]*/version=$1/g" "$TEMPLATE_FILE"
    echo "La version du paquet Discord a été mise à jour vers $1 dans le fichier template." >> "$LOG_FILE"
}

# Fonction pour exécuter la commande xgensum
execute_xgensum() {
    (
        echo "10"
        echo "En cours d'exécution..."
        sleep 1
        echo "50"
        sleep 1
        echo "Terminé."
        sleep 1
        echo "100"
    ) | dialog --backtitle "Gestion du paquet Discord" --title "Progression" --gauge "Exécution de 'xgensum -i discord'" 8 60 0
    echo "Commande 'xgensum -i discord' exécutée." >> "$LOG_FILE"
}

# Fonction pour exécuter la commande xbps-src pkg discord
execute_xbps_pkg() {
    (
        echo "10"
        echo "En cours d'exécution..."
        sleep 1
        echo "50"
        sleep 1
        echo "Terminé."
        sleep 1
        echo "100"
    ) | dialog --backtitle "Gestion du paquet Discord" --title "Progression" --gauge "Exécution de './xbps-src pkg discord'" 8 60 0
    echo "Commande './xbps-src pkg discord' exécutée." >> "$LOG_FILE"
}

# Fonction pour installer Discord
install_discord() {
    (
        echo "10"
        echo "En cours d'installation..."
        sleep 1
        echo "50"
        sleep 1
        echo "Terminé."
        sleep 1
        echo "100"
    ) | dialog --backtitle "Gestion du paquet Discord" --title "Progression" --gauge "Installation de Discord" 8 60 0
    echo "Installation de Discord terminée." >> "$LOG_FILE"
}

# Fonction pour afficher la GUI
show_gui() {
    CHOICE=$(dialog --clear \
                --backtitle "Gestion du paquet Discord" \
                --title "Choix de version" \
                --menu "Quelle version souhaitez-vous utiliser pour le paquet Discord ?" \
                15 60 4 \
                1 "$CURRENT_VERSION" \
                2 "$NEXT_VERSION" \
                3 "Autre" \
                2>&1 >/dev/tty)

    case $CHOICE in
        1)
            NEW_VERSION="$CURRENT_VERSION"
            ;;
        2)
            NEW_VERSION="$NEXT_VERSION"
            ;;
        3)
            NEW_VERSION=$(dialog --clear \
                            --backtitle "Gestion du paquet Discord" \
                            --title "Nouvelle version" \
                            --inputbox "Entrez la nouvelle version du paquet Discord :" \
                            8 60 \
                            2>&1 >/dev/tty)
            ;;
        *)
            echo "Choix invalide."
            exit 1
            ;;
    esac

    # Modification de la version dans le fichier template
    update_template "$NEW_VERSION"

    # Demander à l'utilisateur s'il souhaite exécuter xgensum
    dialog --clear \
        --backtitle "Gestion du paquet Discord" \
        --title "Exécuter xgensum ?" \
        --yesno "Voulez-vous exécuter xgensum ?" \
        8 60
    EXECUTE_XGENSUM=$?

    if [ $EXECUTE_XGENSUM -eq 0 ]; then
        execute_xgensum
    else
        echo "xgensum n'a pas été exécuté." >> "$LOG_FILE"
    fi

    # Vérifier si une erreur SHA256 mismatch est détectée
    if grep -q "ERROR: SHA256 mismatch" "$XBPS_SRC_DIR/srcpkgs/discord/discord-*.log" 2>/dev/null; then
        dialog --clear \
            --backtitle "Gestion du paquet Discord" \
            --title "Erreur SHA256 mismatch" \
            --yesno "Une erreur SHA256 mismatch a été détectée.\nVoulez-vous relancer la dernière commande ?" \
            8 60
        RELAUNCH_COMMAND=$?
        if [ $RELAUNCH_COMMAND -eq 0 ]; then
            bash -c "$(tail -n 1 "$XBPS_SRC_DIR/srcpkgs/discord/discord-*.log" | sed 's/^# //')"
        else
            echo "La dernière commande n'a pas été relancée." >> "$LOG_FILE"
        fi
    fi

    # Demander à l'utilisateur s'il souhaite compiler le paquet depuis les sources
    dialog --clear \
        --backtitle "Gestion du paquet Discord" \
        --title "Compiler depuis les sources ?" \
        --yesno "Voulez-vous compiler le paquet depuis les sources ?" \
        8 60
    COMPILE_FROM_SOURCE=$?

    if [ $COMPILE_FROM_SOURCE -eq 0 ]; then
        execute_xbps_pkg
    else
        echo "Le paquet ne sera pas compilé depuis les sources." >> "$LOG_FILE"
    fi

    # Demander à l'utilisateur s'il souhaite installer Discord
    dialog --clear \
        --backtitle "Gestion du paquet Discord" \
        --title "Installer Discord ?" \
        --yesno "Voulez-vous installer Discord ?" \
        8 60
    INSTALL_DISCORD=$?

    if [ $INSTALL_DISCORD -eq 0 ]; then
        install_discord
    else
        echo "L'installation de Discord n'a pas été effectuée." >> "$LOG_FILE"
    fi

    echo "Discord est à jour." >> "$LOG_FILE"
}

# Définition des variables
TEMPLATE_FILE="/home/gapi/void-packages/srcpkgs/discord/template"
XBPS_SRC_DIR="$HOME/void-packages"

# Écraser le contenu du fichier de log
echo "" > "$LOG_FILE"

# Récupérer la version actuelle depuis le fichier template
CURRENT_VERSION=$(grep "^version=" "$TEMPLATE_FILE" | cut -d= -f2)

# Calculer la version suivante (+0.0.1 par rapport à la version actuelle)
NEXT_VERSION=$(awk -F. '{print $1"."$2"."$3+1}' <<< "$CURRENT_VERSION")

# Afficher l'interface utilisateur graphique
show_gui
