#!/bin/bash

/etc/init.d/mysql start
(cd /servers/solr; ./start_tomcat.sh)
(cd /servers/$PROJECT_NAME; ./start_tomcat.sh)
/usr/sbin/apache2ctl start

tail -f /servers/$PROJECT_NAME/logs/catalina.out

#/usr/sbin/apache2ctl -D FOREGROUND

