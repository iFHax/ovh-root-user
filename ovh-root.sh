#!/bin/bash
 
get_ip() {
    ip=$(hostname -I | awk '{print $1}')
    echo "$ip"
}

# Enable root login for SSH
echo "Modifying SSH configuration to allow root login..."
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
 
echo "Setting root password..."
read -s -p "Enter new root password: " root_password
echo
read -s -p "Confirm new root password: " root_password_confirm
echo

# Check if passwords match
if [ "$root_password" != "$root_password_confirm" ]; then
    echo "Passwords do not match. Exiting..."
    exit 1
fi

echo "root:$root_password" | sudo chpasswd


echo "Restarting SSH service..."
sudo systemctl restart sshd

echo "Root login via SSH is now enabled."
echo "Username: root"
echo "Password: $root_password"
echo "IP Address: $(get_ip)"

sleep 10
reboot
