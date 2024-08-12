#!/bin/bash

# Load KVM module if not already loaded
if command -v lsmod &> /dev/null && command -v modprobe &> /dev/null; then
    if ! lsmod | grep -q kvm; then
        modprobe kvm
    fi
    if ! lsmod | grep -q kvm_intel; then
        modprobe kvm_intel
    fi
else
    echo "kmod tools (lsmod/modprobe) not available, skipping KVM module loading"
fi

# Start the VM in headless mode (no graphics)
qemu-system-x86_64 -m 1024 -hda /var/lib/libvirt/images/edge_device.img -cdrom /tmp/alpine.iso -boot d -enable-kvm -nographic &

sleep 60

# Start the VM in headless mode for further commands
qemu-system-x86_64 -m 1024 -hda /var/lib/libvirt/images/edge_device.img -enable-kvm -nographic &

ssh root@localhost -p 2222 "apk add docker && rc-update add docker boot && service docker start"

scp -P 2222 /tmp/flask_api_app.tar root@localhost:/tmp/
ssh root@localhost -p 2222 "docker load -i /tmp/flask_api_app.tar && docker run -d -p 5000:5000 --name flask_api_app_container flask_api_app"

tail -f /dev/null
