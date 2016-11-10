#!/bin/bash

export CATALINA_HOME=/servers/tomcat
export CATALINA_BASE=`pwd`

${CATALINA_HOME}/bin/catalina.sh stop -force

