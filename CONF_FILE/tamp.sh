#!/usr/bin/env bash

option="${1}" 
case ${option} in 
   -start) 
	   if ps -C httpd >/dev/null; then
		   echo "Dịch vụ apache2 đang chạy..."
	   else

	   spinner=( '█■■■■' '■█■■■' '■■█■■' '■■■█■' '■■■■█' )

		for i in "${spinner[@]}"
		do
        		echo -ne "\033[1;34m\r[\e[1;31m*\e[1;34m] Đang Khởi Động Tamp Server.....\e[34m[\033[31m$i\033[34m]\033[0m   ";
       			sleep .30s
			printf "\b\b\b\b\b\b\b\b";
		done
		httpd &> /dev/null
		mysqld --skip-grant-tables --general-log --user=root --password=Datbao &> /dev/null
		printf "   \b\b\b\b\b"
		printf "\e[1;34m[\e[1;32m Hoàn Tất \e[1;34m]\e[0m";
		echo "";
	   fi
      ;; 
   -stop)
	   spinner=( '█■■■■' '■█■■■' '■■█■■' '■■■█■' '■■■■█' )
	   for i in "${spinner[@]}"
	   do
		   echo -ne "\033[1;34m\r[\e[1;31m*\e[1;34m] Dừng Tamp Server.....\e[34m[\033[31m$i\033[34m]\033[0m   ";
		   sleep .30s
		   printf "\b\b\b\b\b\b\b\b";
	   done
	   h=`pgrep httpd`
	   kill -9 $h &>/dev/null
	   m=`pgrep mysqld`
	   kill -9 $m &>/dev/null
	   printf "   \b\b\b\b\b"
	   printf "\e[1;34m[\e[1;32m Hoàn Tất \e[1;34m]\e[0m";
	   echo "";

      ;;

     -h)
	echo ""
	echo -e "\e[1;38;5;29m<═══════════════ Các Lệnh Tamp ═══════════════>\e[0m"
	echo ""
	echo -e "\e[1;38;5;29mtamp -start  \e[1;38;5;198mBắt đầu\e[0m"
	echo -e "\e[1;38;5;29mtamp -stop   \e[1;38;5;198mDừng\e[0m"
	echo -e "\e[1;38;5;29mtamp -r      \e[1;38;5;198mKhởi động lại\e[0m"
	echo -e "\e[1;38;5;29mtamp -dc     \e[1;38;5;198mThay Đổi Document Root\e[0m"
	echo -e "\e[1;38;5;29mtamp -df     \e[1;38;5;198mĐặt Document Root làm Mặc định\e[0m"
	echo -e "\e[1;38;5;29mtamp -log    \e[1;38;5;198mKiểm tra logs Truy cập & Lỗi http\e[0m"
	echo -e "\e[1;38;5;29mtamp -clog   \e[1;38;5;198mXóa lịch sử logs\e[0m"
	echo -e "\e[1;38;5;29mtamp -un     \e[1;38;5;198mGỡ cài đặt Tamp Server\e[0m"
	echo -e "\e[1;38;5;29mtamp -v      \e[1;38;5;198mKiểm tra phiên bản Tamp\e[0m"
	echo -e "\e[1;38;5;29mtamp -h      \e[1;38;5;198mTrợ giúp\e[0m"
      ;;

    -df)
	PATH1="/data/data/com.termux/files/usr/share/Tamp"
	PATH2="/data/data/com.termux/files/usr/share/Tamp/CONF_FILE"
	PATH3="/data/data/com.termux/files/usr/etc/apache2"
	PATH4="/data/data/com.termux/files/usr/etc/apache2/extra"
	DF_PATH="/data/data/com.termux/files/usr/share/apache2/default-site/htdocs"
	cp $PATH2/httpd.conf $PATH1
	cp $PATH2/httpd-vhosts.conf $PATH1
	sed -i $'s+dc_path_manual+'$DF_PATH'+g' $PATH1/httpd.conf
	sed -i $'s+dc_path_manual+'$DF_PATH'+g' $PATH1/httpd-vhosts.conf
	mv $PATH1/httpd.conf $PATH3
	mv $PATH1/httpd-vhosts.conf $PATH4
	printf "\e[1;32mThành công khi chuyển về mặc định\e[0m\n"
      ;;
      
    -dc)
	PATH1="/data/data/com.termux/files/usr/share/Tamp"
	PATH2="/data/data/com.termux/files/usr/share/Tamp/CONF_FILE"
	PATH3="/data/data/com.termux/files/usr/etc/apache2"
	PATH4="/data/data/com.termux/files/usr/etc/apache2/extra"
	cp $PATH2/httpd.conf $PATH1
	cp $PATH2/httpd-vhosts.conf $PATH1
	read -p $'\n\e[1;34m[\e[1;32m+\e[1;34m]Nhập Đường dẫn Document Root mới\e[1;31m:- \e[0m' dc_path
	sed -i 's+dc_path_manual+'$dc_path'+g' $PATH1/httpd.conf
	sed -i 's+dc_path_manual+'$dc_path'+g' $PATH1/httpd-vhosts.conf
	mv $PATH1/httpd.conf $PATH3
	mv $PATH1/httpd-vhosts.conf $PATH4
	printf "\e[1;32mThành công khi thay đổi\e[0m\n"
      ;;
     -un)
	     LOG_PATH="/data/data/com.termux/files/usr/var/log/apache2"
	     choice=""
	     printf "\e[1;34mBạn có muốn gỡ cài đặt Tamp web server không [\e[1;31my/n\e[1;34m]\e[0m:- "
	     read choice
	     if [[ "${choice}" = "y" ]] || [[ "${choice}" = "Y" ]]; then
		     echo -e "\e[1;34m[\e[1;31m~\e[1;34m]\e[1;31m Đang gỡ cài đặt Tamp web server.....\e[0m"
		     for i in apache2 mariadb php php-apache phpmyadmin; do
			     dpkg -s $i &>/dev/null
			     echo -e "\e[1;0mĐang gỡ cài đặt \e[1;31m$i"
			     apt purge $i -y &>/dev/null
		     done
		     apt autoremove -y &>/dev/null
		     echo -e "\e[1;34m[\e[1;31m~\e[1;34m]\e[1;31mĐang xóa thư mục & Tập tin của Tamp...\e[0m"
		     rm -rf /data/data/com.termux/files/usr/share/Tamp
		     rm /data/data/com.termux/files/usr/bin/tamp
		     rm $LOG_PATH/localhost_Access_log
		     rm $LOG_PATH/localhost_Error_log
		     rm $LOG_PATH//phpmyadmin_Access_log
		     rm $LOG_PATH/phpmyadmin_Error_log
		     echo -e "\e[1;34m[\e[1;32m Hoàn Tất \e[1;34m]\e[0m"
	     elif [[ "${choice}" = "n" ]] || [[ "${choice}" = "N" ]]; then
		     exit 0 
	     else
		     echo -e "\e[1;31mNhập không đúng!\e[0m"
	     fi
      ;;
     -r)
	spinner=( '█■■■■' '■█■■■' '■■█■■' '■■■█■' '■■■■█' )
	for i in "${spinner[@]}"
	do
	echo -ne  "\033[1;34m\r[\e[1;31m*\e[1;34m] Đang khởi động lại Tamp Server.....\e[34m[\033[31m$i\033[34m]\033[0m   ";
	sleep .30s
	printf "\b\b\b\b\b\b\b\b";
        done
	h=`pgrep httpd`
	kill -9 $h &>/dev/null
	m=`pgrep mysqld`
	kill -9 $m &>/dev/null
	if [[ -f /data/data/com.termux/files/usr/var/run/apache2/httpd.pid ]]; then
		rm /data/data/com.termux/files/usr/var/run/apache2/httpd.pid
		httpd &> /dev/null
		mysqld --skip-grant-tables --general-log --user=root --password=Datbao &> /dev/null
	else
		httpd &> /dev/null
		mysqld --skip-grant-tables --general-log --user=root --password=Datbao &> /dev/null
	fi
	if [[ -e /data/data/com.termux/files/usr/var/lib/mysql/ib_logfile0 ]]; then
		rm /data/data/com.termux/files/usr/var/lib/mysql/ib_logfile0
	else
		echo "Không tìm thấy ib_logfile0 trong var/lib/mysql"
	fi
	if ps -C mysqld &> /dev/null; then
		echo "mysqld đang chạy"
	else 
		mysqld_safe --skip-grant-tables --general-log --user=root --password=Datbao &> /dev/null
	fi
	printf "   \b\b\b\b\b"
	printf "\e[1;34m[\e[1;32m Hoàn Tất \e[1;34m]\e[0m";
	echo ""
      ;;
      -log)
	      LOG_PATH="/data/data/com.termux/files/usr/var/log/apache2"
	      cd $LOG_PATH
	      watch tail localhost_Access_log localhost_Error_log phpmyadmin_Access_log phpmyadmin_Error_log
	      cd $HOME
      ;;
     -clog)
	     LOG_PATH="/data/data/com.termux/files/usr/var/log/apache2"
	     if [[ -e $LOG_PATH/localhost_Access_log ]]; then
		     rm $LOG_PATH/localhost_Access_log
		     touch $LOG_PATH/localhost_Access_log
	     else
		     touch $LOG_PATH/localhost_Access_log
	     fi
	     if [[ -e $LOG_PATH/localhost_Error_log ]]; then
		     rm $LOG_PATH/localhost_Error_log
		     touch $LOG_PATH/localhost_Error_log
	     else
		     touch $LOG_PATH/localhost_Error_log
	     fi
	     if [[ -e $LOG_PATH/phpmyadmin_Access_log ]]; then
		     rm $LOG_PATH/phpmyadmin_Access_log
		     touch $LOG_PATH/phpmyadmin_Access_log
	     else
		     touch $LOG_PATH/phpmyadmin_Access_log
	     fi
	     if [[ -e $LOG_PATH/phpmyadmin_Errot_log ]]; then
		     rm $LOG_PATH/phpmyadmin_Errot_log
		     touch $LOG_PATH/phpmyadmin_Errot_log
	     else
		     touch $LOG_PATH/phpmyadmin_Errot_log
	     fi
	     printf "\e[1;32mĐã xóa lịch sử logs thành công\e[0m\n"

      ;;
    -v)
	    echo "Tamp 1.0 (Webserver) ( xây dựng vào ngày 27 tháng 7 năm 2021 )"
	    echo "Bản quyền (c) techx"
     ;;
   *)  
      echo -e "`basename ${0}`: sử dụng\e[38;5;198m:\e[0m tamp \e[38;1;198m-options\e[0m\nthử lại\e[38;5;198m:\e[0m tamp \e[38;5;198m-h\e[0m để được trợ giúp" 
      exit 1 # Lệnh để thoát khỏi chương trình với trạng thái 1
      ;; 
esac
#ib_logfile0
