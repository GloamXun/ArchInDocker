#!/bin/bash

USERNAME=your_username

/usr/bin/sshd -D &
su - $USERNAME -c "code-server &"
su - $USERNAME -c "mkdir -p ~/Projects"

wait
