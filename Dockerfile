FROM ubuntu:18.04

MAINTAINER Simone Roberto Nunzi "simone.roberto.nunzi@gmail.com"

# Install required software
RUN apt-get update && apt-get install -y build-essential sudo git wget zip genisoimage bc squashfs-tools xorriso tar klibc-utils iproute2 dosfstools rsync unzip findutils iputils-ping grep

# Download isorespin script
RUN wget -O isorespin.sh "https://drive.google.com/uc?export=download&id=0B99O3A0dDe67S053UE8zN3NwM2c"

RUN mkdir /docker-input
RUN mkdir /docker-output
RUN mkdir /services

COPY ./docker-entrypoint.sh /
COPY ./build.sh /
COPY ./wrapper-network.sh /
COPY ./wrapper-nvidia.sh /
COPY ./services/gpuoff.service /services/

RUN chmod +x docker-entrypoint.sh
RUN chmod +x build.sh
RUN chmod +x wrapper-network.sh
RUN chmod +x wrapper-nvidia.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
