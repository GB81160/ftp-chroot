#!/bin/bash

# Fonction pour démarrer le serveur FTP
start_ftp_server() {
    sudo systemctl restart vsftpd
    echo -e ".\n---\n"
    echo "  "
    echo "Le serveur FTP a été démarré localement."
    echo "Vous pouvez y accéder en local en utilisant l'URL ftp://$(ip route list | grep -Eo 'src (addr:)?([0-9]*\.){3}[0-9]*' | tr -d ' src'):21"
    echo "Votre nom d'utilisateur et mot de passe sont les mêmes que ceux de votre compte Linux."
    echo -e "\nTous les services ont été démarrés ! :)"
}

# Fonction pour arrêter le serveur FTP
stop_ftp_server() {
    sudo systemctl stop vsftpd
    echo -e "---\nTous les services ont été arrêtés !"
}

# Fonction pour autoconfigurer vsftpd
autoconfigure_vsftpd() {
    # Ajout des paramètres de configuration au fichier vsftpd.conf
    echo -e "chown_username=$USER\nanonymous_enable=NO\nlocal_enable=YES\nwrite_enable=YES\ndirmessage_enable=YES\nxferlog_enable=YES\nconnect_from_port_20=YES\nchroot_local_user=YES\nchroot_list_enable=NO\nlisten=YES\npam_service_name=vsftpd\nallow_writeable_chroot=YES" | sudo tee /etc/vsftpd.conf

    # Sauvegarde du fichier de configuration original
    sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.backup

    # Redémarrage du service vsftpd
    sudo systemctl restart vsftpd

    # Messages pour l'utilisateur
    echo "Le serveur FTP a été configuré automatiquement."
    echo "Vous pouvez y accéder en local en utilisant l'URL ftp://$(ip route list | grep -Eo 'src (addr:)?([0-9]*\.){3}[0-9]*' | tr -d ' src'):21"
    echo "Votre nom d'utilisateur et mot de passe sont les mêmes que ceux de votre compte Linux."
    echo -e "Terminé ! Redémarrez le script pour ARRÊTER ou DÉMARRER le serveur FTP."
}

# Fonction pour installer vsftpd en fonction de la distribution
install_vsftpd() {
    OSInfo=$(cat /etc/*-release)
    if [[ $OSInfo =~ Manjaro ]]; then
        sudo pacman -Sy --noconfirm vsftpd
    elif [[ $OSInfo =~ Red ]]; then
        sudo yum install vsftpd
    elif [[ $OSInfo =~ Debian ]]; then
        sudo apt-get update
        sudo apt-get install vsftpd
    else
        echo "Distribution non prise en charge."
    fi
    echo -e "Terminé ! Redémarrez le script pour AUTOMATISER la configuration."
}

echo "#####################################"
echo "#          FTP Config  v1.1         #"
echo "#####################################"
echo " "
echo "*   Entrez '1' pour DÉMARRER le serveur FTP"
echo "*   Entrez '0' pour ARRÊTER le serveur FTP"
echo "------------------------------------"
echo "*   Entrez 'a' pour AUTOCONFIGURER vsftpd"
echo "*   Entrez 'i' pour INSTALLER vsftpd"
echo "------------------------------------"
echo -n "*   Votre choix : "
read option

case $option in
    1) start_ftp_server ;;
    0) stop_ftp_server ;;
    a) autoconfigure_vsftpd ;;
    i) install_vsftpd ;;
    *) echo "Option non valide." ;;
esac
