sudo localectl set-locale LANG=en_CA.utf8
sudo timedatectl set-timezone America/Toronto
#sudo yum -y update
#sudo yum install deltarpm wget mc telnet unzip git bind-utils jq iscsi-initiator-utils nfs-utils -y

#echo "............."
#echo "Modify sysctl entries"
#sudo tee -a /etc/sysctl.d/99-kubernetes.conf <<EOF
#net.bridge.bridge-nf-call-iptables  = 1
#net.ipv4.ip_forward                 = 1
#net.bridge.bridge-nf-call-ip6tables = 1
#EOF

#echo "installing docker"
#echo "................."
#curl https://releases.rancher.com/install-docker/19.03.sh | sudo bash -
#sudo systemctl enable --now docker

#echo "add user rke to dockergroup"
#echo "..........................."
#sudo usermod -aG docker rke

#sudo sed -i '/ 2001 /s/^/#/' 

#echo "change AllowTCPForwarding"
#sudo sed -i '/AllowTcpForwarding yes/s/^#//g' /etc/ssh/sshd_config
#sudo systemctl restart sshd

echo "add admin user and keypair"
sudo useradd admin -d /home/admin
sudo usermod -aG wheel admin
sudo echo "admin ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers.d/admin
sudo chmod 440 /etc/sudoers.d/admin
sudo -u admin mkdir /home/admin/.ssh
sudo chmod 700 /home/admin/.ssh
sudo echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCXsPKb5aPuVkOssSNpWmS4xdtjNZ0GuIm8ubpHWWer+c9XOnaR5asU1mIv+SnOxybgO5mRiGKcKOY44GSTFcxoPC9d7C3PlJ0Vh8GgiRASov7MkWorqpFmlqG4lACZsSXsmGtspzSJp7ScD3YQ/4FyPYiWaxBKVZvFVCUEzB6ZClefeg3o+BoAyymjwjzixBehaiwwDX61xup5i2G9whZulKbsJBu3CrpVyiaMYdfBB8+RiNCg9GRDZeQfRmswd6IB8awoysiKvRLH87ITsOC4KgqM9xDloWVrtQYQsAb8IXKNN4/pWd85xPZMZ6N57lmR4KOL8llcxflxVT0u4WP3 jerry.li@PC08XUEJ" >> /home/admin/.ssh/authorized_keys
sudo chmod 600 /home/admin/.ssh/authorized_keys
sudo chown admin:admin /home/admin/.ssh/authorized_keys
# add rancher.my-azure.online ca 
sudo cp /home/vagrant/ca_bundle.crt /etc/pki/ca-trust/source/anchors/
sudo update-ca-trust
