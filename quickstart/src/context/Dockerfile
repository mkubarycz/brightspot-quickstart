# Brightspot Quickstart
FROM ubuntu:14.04
MAINTAINER Perfect Sense Digital

ENV PROJECT_NAME {{projectName}}

# install java 8
RUN apt-get update && apt-get install -y \
    software-properties-common \
    python-software-properties \
    && add-apt-repository -y ppa:webupd8team/java && apt-get update \
    && echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections \
    && apt-get install -y oracle-java8-installer oracle-java8-set-default

# install maven
RUN apt-get -y install maven


# install mysql
COPY configs/mysql /servers/configs/mysql
RUN echo "mysql-server mysql-server/root_password password demo" | debconf-set-selections \
    && echo "mysql-server mysql-server/root_password_again password demo" | debconf-set-selections \
    && apt-get update && apt-get install -y mysql-server \
    && cp /servers/configs/mysql/* /etc/mysql/ \
    && /etc/init.d/mysql start \
    && echo "CREATE DATABASE IF NOT EXISTS $PROJECT_NAME" | mysql -u root -pdemo



# install apache / mod_dims
COPY configs/apt/PERFECTSENSE-GPG-KEY.public /etc/
COPY configs/apt/repo.psdops.com.pref /etc/apt/preferences.d/
RUN apt-key add /etc/PERFECTSENSE-GPG-KEY.public \
    && add-apt-repository 'deb     [arch=amd64] http://repo.psdops.com/apt/trusty/ trusty main' \
    && apt-get update \
    && apt-get install -y apache2 mod-dims
# copy apache configs from the context
COPY configs/apache /servers/configs/apache
# install additional apache modules, copy some custom configs
RUN a2enmod proxy_http \
    && a2enmod rewrite \
    && cp /servers/configs/apache/conf-enabled/* /etc/apache2/conf-enabled/ \
    && cp /servers/configs/apache/sites-enabled/* /etc/apache2/sites-enabled/000-default.conf



# copy tomcat from context
ADD distro/tomcat.tar.gz /servers/distro/

# install tomcat
RUN mkdir -p /servers/tomcat/webapps \
    && cp -r /servers/distro/tomcat/bin /servers/tomcat/bin \
    && cp -r /servers/distro/tomcat/lib /servers/tomcat/lib \
    && cp -r /servers/distro/tomcat/webapps/manager /servers/tomcat/webapps/manager \
    && cp -r /servers/distro/tomcat/webapps/host-manager /servers/tomcat/webapps/host-manager



# copy the solr configs from the context
COPY configs/tomcat_solr /servers/configs/tomcat_solr

# install solr into tomcat from local distro
WORKDIR /servers/solr
RUN mkdir -p bin lib logs temp webapps solr \
    && cp -r /servers/distro/tomcat/conf conf \
    && cp /servers/configs/tomcat_solr/conf/* conf \
    && cp /servers/configs/tomcat_solr/lib/* lib \
    && cp /servers/configs/tomcat_solr/bin/* bin \
    && cp /servers/configs/tomcat_solr/webapps/* webapps \
    && cp -r /servers/configs/tomcat_solr/solr . \
    && cp /servers/configs/tomcat_solr/home/* .



# copy the project configs from the context
COPY configs/tomcat_project /servers/configs/tomcat_project

# install demo project into tomcat from local distro
WORKDIR /servers/$PROJECT_NAME
RUN mkdir -p bin lib logs temp webapps \
    && cp -r /servers/distro/tomcat/conf conf \
    && cp /servers/configs/tomcat_project/conf/* conf \
    && cp /servers/configs/tomcat_project/lib/* lib \
    && cp /usr/lib/jvm/java-8-oracle/lib/tools.jar lib \
    && cp /servers/configs/tomcat_project/bin/* bin \
    && cp /servers/configs/tomcat_project/home/* . \
    && ln -s /servers/tomcat/webapps/manager webapps/manager \
    && ln -s /servers/tomcat/webapps/host-manager webapps/host-manager

# start mysql
RUN /etc/init.d/mysql start \
    && mysql -u root -pdemo -D $PROJECT_NAME

EXPOSE 8080

COPY configs/docker/entrypoint.sh /servers/

ENTRYPOINT ["/servers/entrypoint.sh"]

