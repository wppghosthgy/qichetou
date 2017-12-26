#!/bin/bash

if [ ! -f /past-sshd ]; then
    echo "Setting root password to ${ROOT_PASSWORD}..."
    echo "root:${ROOT_PASSWORD}" |chpasswd
    touch /past-sshd
    echo "Creating SSH keys..."
    rm /etc/ssh/ssh_host_dsa_key
    # dpkg-reconfigure openssh-server
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_dsa_key -N ''
fi 

# Enable google-auth
if [ "${GOOGLE_AUTHENTICATOR_ENABLE}" == "true" ] && [ ! -f /root/.google_authenticator ]; then
    echo "Creating a new key for Google Authenticator otp authentication..."
    google-authenticator -t -d -f -r 5 -R 30 -w 3
fi

/usr/sbin/sshd -E /var/log/sshd.log
tail -f /var/log/sshd.log
