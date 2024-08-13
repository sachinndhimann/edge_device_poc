#!/bin/bash

# Ensure no other process is using the QEMU image
fuser -k /var/lib/libvirt/images/edge_device.img

# Start the VM in headless mode (no graphics)
#qemu-system-x86_64 -no-kvm -m 1024 -hda /var/lib/libvirt/images/edge_device.img -cdrom /tmp/alpine.iso -boot d -nographic &
qemu-system-x86_64 -no-kvm -m 2048  -hda /var/lib/libvirt/images/edge_device.img \
-netdev user,id=n0,hostfwd=tcp::2222-:22 -device virtio-net-pci,netdev=n0 \
-cdrom /tmp/alpine.iso -boot d -nographic &
# Wait for the VM to boot and SSH service to start
echo "Waiting for vm to boot........"
sleep 50

# Start SSH service
service ssh start
echo "ssh started..."
# Wait for SSH service to initialize
sleep 20

ssh -o ServerAliveInterval=60 root@localhost -p 2222
# Execute SSH commands
sshpass -p 'your_password' ssh -o StrictHostKeyChecking=no -o KexAlgorithms=+diffie-hellman-group1-sha1 root@localhost -p 2222 "apk add docker && rc-update add docker boot && service docker start"

# Transfer and run Docker container
scp -P 2222 /tmp/flask_api_app.tar root@localhost:/tmp/
sshpass -p 'your_password' ssh -o StrictHostKeyChecking=no root@localhost -p 2222 "docker load -i /tmp/flask_api_app.tar && docker run -d -p 5000:5000 --name flask_api_app_container flask_api_app"

# Keep the container running
tail -f /dev/null
