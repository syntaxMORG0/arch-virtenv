FROM archlinux:latest

RUN pacman -Syu --noconfirm base-devel sudo git bash nasm gcc hexyl openssh \
 && echo 'export PS1="[\w]# "' > /root/.bashrc \
 && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
 && locale-gen

SHELL ["/bin/bash", "-c"]

RUN useradd -m devuser && echo "devuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER devuser
WORKDIR /home/devuser