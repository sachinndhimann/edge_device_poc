FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    qemu \
    qemu-kvm \
    libvirt-daemon-system \
    libvirt-clients \
    bridge-utils \
    wget \
    curl \
    kmod  # This installs lsmod and modprobe

RUN apt-get clean

RUN wget -O /tmp/alpine.iso https://dl-cdn.alpinelinux.org/alpine/v3.15/releases/x86_64/alpine-standard-3.15.0-x86_64.iso

RUN qemu-img create -f qcow2 /var/lib/libvirt/images/edge_device.img 10G

COPY flask_api_app.tar /tmp/flask_api_app.tar
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 5000
EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]