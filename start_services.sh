#!/bin/bash
/usr/bin/sshd -D &
code-server &
su - code
