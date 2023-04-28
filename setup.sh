#!/bin/bash

#this bash script is to 
#check the flavour of linux 
#install update the version of linux
#install docker Opensource
#Get the stack Defined yml stack and install following
## Nginx Proxy Manager
## Mysql
## PhpMyAdmin
## n8n with preconfigured credentials

# Set history file to /dev/null
HISTFILE=/dev/null

# Run the script
#!/bin/bash

# Check the Linux flavor
if [[ -f /etc/redhat-release ]]; then
    linux_flavor="redhat"
elif [[ -f /etc/arch-release ]]; then
    linux_flavor="arch"
elif [[ -f /etc/gentoo-release ]]; then
    linux_flavor="gentoo"
elif [[ -f /etc/SuSE-release ]]; then
    linux_flavor="suse"
elif [[ -f /etc/debian_version ]]; then
    linux_flavor="debian"
elif [[ -f /etc/lsb-release ]]; then
    source /etc/lsb-release
    linux_flavor=$DISTRIB_ID
elif [[ -f /etc/alpine-release ]]; then
    linux_flavor="alpine"
else
    echo "Unsupported Linux flavor. Exiting."
    exit 1
fi

# Update the package manager and OS
if [[ $linux_flavor == "redhat" ]]; then
    sudo yum update -y
elif [[ $linux_flavor == "arch" ]]; then
    sudo pacman -Syu --noconfirm
elif [[ $linux_flavor == "gentoo" ]]; then
    sudo emerge --sync
    sudo emerge --update --deep --newuse @world
elif [[ $linux_flavor == "suse" ]]; then
    sudo zypper refresh
    sudo zypper update -y
elif [[ $linux_flavor == "debian" ]]; then
    sudo apt update && sudo apt upgrade -y
elif [[ $linux_flavor == "ubuntu" ]]; then
    sudo apt update && sudo apt upgrade -y
elif [[ $linux_flavor == "alpine" ]]; then
    sudo apk update
    sudo apk upgrade
fi

# Install Docker
if [[ $linux_flavor == "redhat" ]]; then
    sudo yum install -y docker
elif [[ $linux_flavor == "arch" ]]; then
    sudo pacman -S --noconfirm docker
elif [[ $linux_flavor == "gentoo" ]]; then
    sudo emerge --ask app-emulation/docker
elif [[ $linux_flavor == "suse" ]]; then
    sudo zypper install -y docker
elif [[ $linux_flavor == "debian" ]]; then
    sudo apt install -y docker.io
elif [[ $linux_flavor == "ubuntu" ]]; then
    sudo apt install -y docker.io
elif [[ $linux_flavor == "alpine" ]]; then
    sudo apk add docker
fi

# Check if Docker is running
if sudo systemctl is-active --quiet docker; then
    echo "Docker is running."

    # Fetch Docker Compose file and deploy Docker stack
    curl -O https://raw.githubusercontent.com/himanshuja/setup/main/docker-compose.yml
    sudo docker-compose up -d

    # Return Docker installation environment file details
    docker_info=$(sudo docker system info)
    echo "$docker_info"
else
    echo "Docker is not running."
fi


    # Remove the script file
    rm "$0"
} &>/dev/null & disown

# Exit the current shell
exit
