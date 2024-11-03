FROM archlinux:latest

# change these settings
ENV ROOT_PASSWORD=your_password
ENV CODE_SERVER_PASSWORD=your_password
ENV USER=your_username

ENV HOME_DIR=/home/${USER}

RUN pacman -Sy --noconfirm && \
    pacman -S --noconfirm openssh sudo git base-devel

RUN sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

RUN echo "root:${ROOT_PASSWORD}" | chpasswd

RUN useradd -m -G wheel ${USER} && \
    echo "${USER}:${ROOT_PASSWORD}" | chpasswd && \
    echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

RUN ssh-keygen -A && \
    ssh-keygen -q -N '' -f /etc/ssh/ssh_host_key

RUN git clone https://aur.archlinux.org/yay.git ${HOME_DIR}/yay && \
    chown -R ${USER}:${USER} ${HOME_DIR}/yay && \
    cd ${HOME_DIR}/yay && \
    sudo -u ${USER} makepkg -si --noconfirm && \
    rm -rf ${HOME_DIR}/yay

RUN sudo -u ${USER} yay -S --noconfirm code-server

RUN mkdir -p ${HOME_DIR}/.config/code-server && \
    echo "bind-addr: 0.0.0.0:8080" > ${HOME_DIR}/.config/code-server/config.yaml && \
    echo "auth: password" >> ${HOME_DIR}/.config/code-server/config.yaml && \
    echo "password: ${CODE_SERVER_PASSWORD}" >> ${HOME_DIR}/.config/code-server/config.yaml

RUN sudo -u ${USER} yay -Yc --noconfirm && \
    rm -rf ${HOME_DIR}/.cache/yay && \
    rm -rf /var/cache/pacman/pkg/* /var/lib/pacman/sync/*

COPY start_services.sh /usr/local/bin/start_services.sh
RUN chmod +x /usr/local/bin/start_services.sh

CMD ["/usr/local/bin/start_services.sh"]

EXPOSE 22 8080

