#!/usr/bin/env bash

# TERMUX APACHE MARIADB PHP WEBSERVER
CONF_FILE_PATH="/storage/emulated/0/DAT_WEB/"

if [ -d "$CONF_FILE_PATH" ]; then
    echo "Thư mục đã tồn tại."
else
    mkdir -p "$CONF_FILE_PATH"
    echo "Thư mục mới đã được tạo."
fi

check_Packages() {
for i in apache2 mariadb php php-apache phpmyadmin; do
	dpkg -s $i &> /dev/null
	if [[ $? -eq 0 ]]; then
		echo -e "\e[1;34m[\e[\e[1;92m+\e[1;34m]\e[1;92m${i}\e[0m is Installed"
	else
		echo -e "\e[1;34m[\e[1;31m-\e[1;34m]\e[1;31m${i}\e[0m is not Installed"

	fi

done
}
install_Packages() {
for i in apache2 mariadb php php-apache phpmyadmin; do
	dpkg -s $i &> /dev/null
	if [[ $? -eq 0 ]]; then
		echo ""
	else
		echo ""
		echo -e "\e[1;34m[\e[\e[1;33m!\e[1;34m]Installing ${i}………………\e[1;34m[\e[1;32mPlease wait!\e[1;34m]\e[0m"
		sleep 1s
		apt-get install ${i} -y &> /dev/null
		echo ""
		echo -e "\e[1;34m[\e[1;92m+\e[1;34m]\e[1;32m${i}\e[0m Installed Successfully"
	fi
done
}
configure_Files() {
	echo ""
	echo -e "\e[1;34m[\e[1;31m*\e[1;34m]Configure Files\e[0m"
	if [[ -f httpd.conf ]] || [[ -f httpd-vhosts.conf ]]; then
		rm httpd.conf
		rm httpd-vhosts.conf
		cp CONF_FILE/httpd.conf $HOME/Tamp
		cp CONF_FILE/httpd-vhosts.conf $HOME/Tamp
	else
		cp CONF_FILE/httpd.conf $HOME/Tamp
		cp CONF_FILE/httpd-vhosts.conf $HOME/Tamp
	fi
}
document_Root() {
		sed -i 's+dc_path_manual+/storage/emulated/0/DAT_WEB/+g' httpd-vhosts.conf
		sed -i 's+dc_path_manual+/storage/emulated/0/DAT_WEB/+g' httpd.conf
}
set_Up_files() {
	echo ""
	printf "\e[1;34m[\e[1;31m*\e[1;34m]Setting up configuration files.....\e[0m"
	sleep 1
	PATH1="/data/data/com.termux/files/usr/etc/apache2"
	PATH2="/data/data/com.termux/files/usr/etc/apache2/extra/"
	PATH3="/data/data/com.termux/files/usr/etc/phpmyadmin"
	if [[ -f $PATH1/httpd.conf ]]; then
		#if httpd.conf file is exists in apache2 directory
		#remove previous conf file add new config file
		rm $PATH1/httpd.conf
		mv httpd.conf $PATH1
	else
		#In case there is no conf file present in apache2 directory
		mv httpd.conf $PATH1
	fi
	if [[ -f $PATH2/httpd-vhosts.conf ]]; then                                     #if httpd-vhosts.conf is exists in apache2/extra directory
		#Remove previous httpd-vhosts.conf & add new httpd-vhosts.conf
		rm $PATH2/httpd-vhosts.conf
		mv httpd-vhosts.conf $PATH2
        else                                                                           #In case there is no file present in apache2/extra directory
		mv httpd-vhosts.conf $PATH2
	fi
	if [[ -f $PATH3/config.inc.php ]]; then
		rm $PATH3/config.inc.php
		cp CONF_FILE/config.inc.php $PATH3
	else
		#In case there no config.inc.php file then
		cp CONF_FILE/config.inc.php $PATH3
	fi
	if [[ -f $PATH2/php_module.conf ]]; then
		echo -e "\e[1mPhp_module is [\e[1;32m ok \e[0m\e[1m]\e[0m"
	else
		touch $PATH2/php_module.conf
	fi
	printf "\e[1;34m[\e[1;32m Done \e[1;34m]\e[0m\n"

}
install_Tamp() {
	echo -e "\e[1;34m[\e[1;31m*\e[1;34m]Installing Tamp....\e[0m"
	sleep 1s
	TAMP_DIR="/data/data/com.termux/files/usr/share"
	if [[ -d $TAMP_DIR/Tamp ]]; then
		echo -e "\e[1mTamp Directory is [\e[1;32m ok \e[0m\e[1m]\e[0m"
		sleep .2s
	else
		printf "\e[1;34m[\e[1;32m*\e[1;34m]Creating Directory\e[0m"
		mkdir $TAMP_DIR/Tamp
		sleep 1s
		printf "\e[1;34m[\e[1;32m Done \e[1;34m]\e[0m\n"
	fi
	if [[ -d $TAMP_DIR/Tamp/CONF_FILE ]];then
		echo -e "\e[1mConfiguration directory is [\e[1;32m ok \e[0m\e[1m]\e[0m"
		sleep .2s
	else
		printf "\e[1;34m[\e[1;32m*\e[1;34m]Creating Configuration Directory\e[0m"
		mkdir $TAMP_DIR/Tamp/CONF_FILE
		sleep 1s
		printf "\e[1;34m[\e[1;32m Done \e[1;34m]\e[0m\n"
	fi
	if [[ -f $TAMP_DIR/Tamp/CONF_FILE/httpd.conf ]] || [[ -f $TAMP_DIR/Tamp/CONF_FILE/httpd-vhosts.conf ]]; then
		echo -e "\e[1mConfiguration file is [\e[1;32m ok \e[0m\e[1m]\e[0m"
		sleep .2s

	else
		printf "\e[1;34m[\e[1;32m*\e[1;34m]Copying configuration file....\e[0m"
		cp $HOME/Tamp/CONF_FILE/*.conf $TAMP_DIR/Tamp/CONF_FILE 
		sleep 1s
		printf "\e[1;34m[\e[1;32m Done \e[1;34m]\e[0m\n"
	fi
	Tamp_Path="/data/data/com.termux/files/usr/bin"
	if [[ -f $Tamp_Path/tamp ]]; then
		echo -e "\e[1mTamp Web server is [\e[1;32m installed \e[0m\e[1m]\e[0m"
	else
		printf "\e[1;34m[\e[1;32m*\e[1;34m]Installing.....\e[0m"
		sleep 1s
		cp $HOME/Tamp/CONF_FILE/tamp.sh $Tamp_Path
		cd $Tamp_Path
		mv tamp.sh tamp
		chmod +x tamp
		printf "\e[1;34m[\e[1;32m Done \e[1;34m]\e[0m\n"
	fi
}
Log_Files() {
	Log_Path="/data/data/com.termux/files/usr/var/log/apache2"
	if [[ -e $Log_Path/localhost_Access_log ]]; then
		echo ""
		printf "\e[1mLocalhost http Access_log file is [\e[1;32m ok.. \e[0m\e[1m]\e[0m\n"
	else
		touch $Log_Path/localhost_Access_log
	fi
	if [[ -e $Log_Path/localhost_Error_log ]]; then
		printf "\e[1mLocalhost http Error_log file is [\e[1;32m ok.. \e[0m\e[1m]\e[0m\n"
	else
		touch $Log_Path/localhost_Error_log
	fi
	if [[ -e $Log_Path/phpmyadmin_Access_log ]]; then
		printf "\e[1mPhpMyadmin http Access_log file is [\e[1;32m ok.. \e[0m\e[1m]\e[0m\n"
	else
		touch $Log_Path/phpmyadmin_Access_log
	fi
	if [[ -e $Log_Path/phpmyadmin_Error_log ]]; then
		printf "\e[1mPhpMyadmin http Error_log file is [\e[1;32m ok..\e[0m\e[1m]\e[0m\n"
	else
		touch $Log_Path/phpmyadmin_Error_log
	fi
}
banner() {
	echo -e "	\e[1;31m████████\e[1;32m╗ \e[1;31m█████\e[1;32m╗\e[1;31m ███\e[1;32m╗   \e[1;31m███\e[1;32m╗\e[1;31m██████\e[1;32m╗\e[0m"
echo -e "	\e[1;32m╚══\e[1;31m██\e[1;32m╔══╝\e[1;31m██\e[1;32m╔══\e[1;31m██\e[1;32m╗\e[1;31m████\e[1;32m╗ \e[1;31m████\e[1;32m║\e[1;31m██\e[1;32m╔══\e[1;31m██\e[1;32m╗\e[0m"
echo -e "   	   \e[1;31m██\e[1;32m║   \e[1;31m███████\e[1;32m║\e[1;31m██\e[1;32m╔\e[1;31m████\e[1;32m╔\e[1;31m██\e[1;32m║\e[1;31m██████\e[1;32m╔╝\e[0m"
echo -e "   	   \e[1;31m██\e[1;32m║   \e[1;31m██\e[1;32m╔══\e[1;31m██\e[1;32m║\e[1;31m██\e[1;32m║╚\e[1;31m██\e[1;32m╔╝\e[1;31m██\e[1;32m║\e[1;31m██\e[1;32m╔═══╝\e[0m"
echo -e "   	   \e[1;31m██\e[1;32m║  \e[1;31m ██\e[1;32m║  \e[1;31m██\e[1;32m║\e[1;31m██\e[1;32m║ ╚═╝ \e[1;31m██\e[1;32m║\e[1;31m██\e[1;32m║\e[0m"
echo -e "   	   \e[1;32m╚═╝   ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝\e[0m"
echo -e "	\e[1;31m<════\e[1;32mTermux Apache MariaDB Php\e[1;31m════>\e[0m"
echo -e " 	         \e[30;48;5;40m WebServer V 1.0 \e[0m"
}
clear
banner
check_Packages
install_Packages
clear
check_Packages
configure_Files
clear
document_Root
set_Up_files
Log_Files
install_Tamp

