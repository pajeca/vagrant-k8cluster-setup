# -*- mode: ruby -*-
# vi:set ft=ruby sw=2 ts=2 sts=2:

# Define the number of master and worker nodes
# If this number is changed, remember to update setup-hosts.sh script with the new hosts IP details in /etc/hosts of each VM.
NUM_MASTER_NODE = 1
NUM_WORKER_NODE = 2

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  config.vm.box = "generic/ubuntu2204"
  config.vm.box_check_update = true

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  #config.vm.network "public_network"

  config.vm.synced_folder ".", "/vagrant_data", disabled: true
  config.vm.provider "hyperv"

  # Provision Master Nodes
  (1..NUM_MASTER_NODE).each do |i|
      config.vm.define "k8master" do |node|
        node.vm.hostname = "k8master"
        # Name shown in the GUI
        node.vm.provider "hyperv" do |h|
            h.vmname = "k8master"
            h.memory = 2048
            h.cpus = 2
            h.enable_virtualization_extensions = false
            h.linked_clone = true
        end
      end
  end


  # Provision Worker Nodes
  (1..NUM_WORKER_NODE).each do |i|
    config.vm.define "k8worker-node0#{i}" do |node|
      node.vm.hostname = "k8worker-node0#{i}"
        node.vm.provider "hyperv" do |h|
            h.vmname = "k8worker-node0#{i}"
            h.memory = 2048
            h.cpus = 2
            h.enable_virtualization_extensions = false
            h.linked_clone = true
        end
    end
  end
end
