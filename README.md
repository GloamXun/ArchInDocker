# ArchInDocker
This repository contains a Dockerfile that could be used to build an Arch Linux Docker image with SSH and code-server services.

This project can help you to build a remote production environment as fast as possible on a VPS.

## How to Use It

* `git clone` this repository and `cd` into it.
* review the `Dockerfile` and replace `your_password` after the `ROOT_PASSWORD`, `CODE_SERVER_PASSWORD` and `your_username` after `USER` at line 3, 4 and 5
* replace `your_username` after the `USERNAME` in file `start_services.sh` and make sure that `USERNAME` is equal to `USER` in `Dockerfile`
* run the command (don't miss the dot behind):
  `docker build -t whatever-your-image-name:tag .`
* feel free to create your own container, just remember that this image opens port `22` and `8080` to support SSH and code-server services.

## Notice
The password of `USER` is as same as `root` which you've given it at line 3. Finally, `PermitRootLogin` is not allowed, please use `USER` to login.
