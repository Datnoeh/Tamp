#!/usr/bin/env bash

option="${1}" 
case ${option} in 
   -start) 
       if pgrep httpd &>/dev/null; then
           echo "Apache2 is already running..."
       else
           echo "Starting Tamp Server..."
           httpd &> /dev/null
           mysqld --skip-grant-tables --general-log --user=root --password=Datbao &> /dev/null
           echo "Done!"
       fi
      ;; 
   -stop)
       echo "Stopping Tamp Server..."
       h=$(pgrep httpd)
       kill -9 $h &>/dev/null
       m=$(pgrep mysqld)
       kill -9 $m &>/dev/null
       echo "Done!"
      ;;
   -h)
      echo ""
      echo "<═══════════════ Tamp Commands ═══════════════>"
      echo "tamp -start  Start"
      echo "tamp -stop   Stop"
      echo "tamp -r      Restart"
      echo "tamp -dc     Change Document Root"
      echo "tamp -df     Set Document Root to Default"
      echo "tamp -log    Check Access & Error logs"
      echo "tamp -clog   Clear logs history"
      echo "tamp -un     Uninstall Tamp Server"
      echo "tamp -v      Check Tamp version"
      echo "tamp -h      Help"
      ;;
   -df)
      # Code for setting Document Root to Default
      ;;
   -dc)
      # Code for changing Document Root
      ;;
   -un)
      # Code for uninstalling Tamp Server
      ;;
   -r)
      # Code for restarting Tamp Server
      ;;
   -log)
      # Code for checking logs
      ;;
   -clog)
      # Code for clearing logs history
      ;;
   -v)
      echo "Tamp 1.0 (Webserver) (Build date: July 27, 2021)"
      echo "Copyright (c) techx"
      ;;
   *)
      echo "`basename ${0}`: Usage: tamp -options"
      echo "Try `basename ${0}` -h for help"
      exit 1
      ;; 
esac
