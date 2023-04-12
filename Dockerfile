# Start from the code-server Debian base image
FROM debian:bullseye




# Installation
RUN apt-get update -y
RUN apt install sudo -y
RUN sudo apt-get update -y
RUN sudo apt-get upgrade -y
RUN sudo apt install unzip -y
RUN sudo apt update -y
RUN sudo apt install openjdk-17-jre-headless -y
RUN sudo apt install screen -y
RUN sudo apt install wget -y
RUN sudo apt install curl -y
RUN curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list && sudo apt update && sudo apt install ngrok
RUN wget -O server.jar "https://api.papermc.io/v2/projects/paper/versions/1.18.2/builds/388/downloads/paper-1.18.2-388.jar" 

RUN wget -O eula.txt "https://cdn.team-ic.dev/eula.txt"

RUN echo Agreed to Mojang EULA

RUN wget -O ngrok.zip "https://cdn.team-ic.dev/ngrok.zip"

RUN unzip ngrok.zip

RUN apt-get update -y && \
  apt-get upgrade -y && \
  apt install sudo && \ 
  sudo apt-get -y install systemctl && \
  apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common && \
  curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
  apt update -y && \
  apt install -y docker-ce 

ENV SHELL=/bin/bash

COPY . /
RUN chmod +x /start.sh
RUN chmod +x /web.sh

ENTRYPOINT ["/start.sh"]
