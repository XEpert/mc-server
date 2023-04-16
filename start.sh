#!/bin/bash

apt install php -y
apt install nodejs -y
apt install npm -y
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list && sudo apt update && sudo apt install ngrok
# Minecraft version
VERSION=1.18.2
BUILD=216

set -e
root=$PWD
mkdir -p Server
cd Server


download() {
    set -e
    echo By executing this script you agree to the JRE License, the PaperMC license,
    echo the Mojang Minecraft EULA,
    echo the NPM license, the MIT license,
    echo and the licenses of all packages used \in this project.
    echo Thank you \for agreeing, the download will now begin.
    wget -O server.jar "https://api.papermc.io/v2/projects/paper/versions/1.19.2/builds/307/downloads/paper-mojmap-1.19.2-307.jar" 
    wget -O server.properties https://cdn.team-ic.dev/xepert/server.properties
    echo Paper downloaded
    wget -O eula.txt "https://cdn.team-ic.dev/eula.txt"
    echo Server properties&eula.txt downloaded
    echo eula.txt is now true
    wget -O web.sh wget https://cdn.team-ic.dev/yt/web.sh
    echo web.sh downloaded
    mkdir plugins
    cd plugins
    wget https://cdn.team-ic.dev/yt/FileManager_v1.2.jar
    cd ..
    WebConsole done downloaded
    echo "Download complete" 
    

    
}

require() {
    if [ ! $1 $2 ]; then
        echo $3
        echo "Running download..."
        download
    fi
}

require_file() { require -f $1 "File $1 required but not found"; }
require_dir()  { require -d $1 "Directory $1 required but not found"; }
require_env()  {
    var=`python3 -c "import os;print(os.getenv('$1',''))"`
    if [ -z "${var}" ]; then
        echo "Environment variable $1 not set. "
        echo "In your .env file, add a line with:"
        echo "$1="
        echo "and then right after the = add $2"
        exit
    fi
    eval "$1=$var"
}
require_executable() {
    require_file "$1"
    chmod +x "$1"
}

# server files
require_file "eula.txt"
require_file "server.jar"
# server files"
# java
#require_dir "jre"
#require_executable "jre/bin/java"
# ngrok binary

echo "Minecraft server starting, please wait" > $root/status.log
#file manager


# start tunnel
mkdir -p ./logs
touch ./logs/temp # avoid "no such file or directory"
rm ./logs/*
echo "Starting ngrok tunnel in region $ngrok_region"
ngrok authtoken 2N36T75EHrMKDrHxxOjUSE6HH7r_6ytV7LjrEbdmhsee9LSp
ngrok tcp --region in --log=stdout 25565 > $root/status.log &
echo "Server Up!"
echo "Server is now running!" > $root/status.log

# Start minecraft
#PATH=$PWD/jre/bin:$PATH
echo "Running server..."
java -Xmx3G -Xms3G -jar server.jar --nogui
#enable below when you have the replit hacker and u have boosted :)
#java -Xms3G -Xmx4G -jar server.jar --nogui
#java -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -Xms3G -Xmx4G -jar server.jar --nogui
