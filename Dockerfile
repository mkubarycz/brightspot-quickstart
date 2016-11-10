FROM maven:3.3.9-jdk-8
MAINTAINER Michael Kubarycz <michael.kubarycz@golfchannel.com>

COPY ./quickstart /src

WORKDIR /src

ENTRYPOINT ["sh", "./build.sh"]
