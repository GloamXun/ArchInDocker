FROM archlinux:latest

ENV ROOT_PASSWORD=your_password
ENV CODE_SERVER_PASSWORD=your_password

RUN pacman -Sy --noconfirm && \
    pacman -S --noconfirm openssh sudo git base-devel

RUN sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

RUN echo "root:${ROOT_PASSWORD}" | chpasswd

RUN useradd -m -G wheel code && \
    echo "code:${ROOT_PASSWORD}" | chpasswd && \
    echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

RUN ssh-keygen -A && \
    ssh-keygen -q -N '' -f /etc/ssh/ssh_host_key

RUN git clone https://aur.archlinux.org/yay.git /home/code/yay && \
    chown -R code:code /home/code/yay && \
    cd /home/code/yay && \
    sudo -u code makepkg -si --noconfirm && \
    rm -rf /home/code/yay

RUN sudo -u code yay -S --noconfirm code-server

RUN mkdir -p /root/.config/code-server && \
    echo "bind-addr: 0.0.0.0:8080" > /root/.config/code-server/config.yaml && \
    echo "auth: password" >> /root/.config/code-server/config.yaml && \
    echo "password: ${CODE_SERVER_PASSWORD}" >> /root/.config/code-server/config.yaml

RUN sudo -u code yay -Yc --noconfirm && \
    rm -rf /home/code/.cache/yay && \
    rm -rf /var/cache/pacman/pkg/* /var/lib/pacman/sync/*

COPY start_services.sh /usr/local/bin/start_services.sh
RUN chmod +x /usr/local/bin/start_services.sh

CMD ["/usr/local/bin/start_services.sh"]

EXPOSE 22 8080

