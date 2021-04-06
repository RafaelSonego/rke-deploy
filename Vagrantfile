# -*- mode: ruby -*-
# vi: set ft=ruby :
#require 'securerandom'

#random_string1 = SecureRandom.hex
#random_string2 = SecureRandom.hex
#cluster_init_token = "#{random_string1[0..5]}.#{random_string2[0..15]}"

NUM_NODES = 3
NODE_MEM = '6144'

Vagrant.configure('2') do |config|
  (1..NUM_NODES).each do |node_number|
    node_name = "rke-#{node_number}"
    config.vm.define node_name do |node|

      node.vm.box = "bento/centos-8"
      node.vm.box_check_update = false

      node.vm.hostname = "#{node_name}"

      node_address = 14 + node_number
      node_ip = "192.168.31.#{node_address}"
      node.vm.network 'public_network', bridge: "eno1", ip: "#{node_ip}", auto_config: "false"

      node.vm.provider 'virtualbox' do |vb|
        vb.memory = NODE_MEM
        vb.cpus = 6
      end

      # required by kubeadm, needed at every start
      node.vm.provision "shell", inline: "swapoff -a", run: "always"
      node.vm.provision 'shell' do |s|
        s.path = 'setup.sh'
      end

#      node.vm.provision "ansible" do |ansible|
#        ansible.playbook = "provision.yml"
#      end

    end
  end
end
