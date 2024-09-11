IMAGE_NAME = "https://github.com/naveenrajm7/utm-box/releases/download/debian-11/debian_vagrant_utm.zip"
MASTERS = 1
NODES = 2

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false

  # Configure the UTM provider globally
  config.vm.provider :utm do |utm|
    utm.utm_file_url = IMAGE_NAME
    utm.memory = 2048
    utm.cpus = 2
  end

  # Define the master node
  config.vm.define "master" do |master|
    master.vm.hostname = "master"
    master.vm.network "private_network", ip: "192.168.56.10"
    
    master.vm.provision "shell", privileged: true, inline: <<-SHELL
      set -e
      echo "Updating package list..."
      sudo apt-get update
      echo "Installing python3-pip and git..."
      sudo apt-get install -y python3-pip git
      echo "Upgrading pip and installing Ansible and ruamel.yaml..."
      sudo pip3 install --upgrade "ansible>=2.16.4,<2.17.0" ruamel.yaml
      echo "Cloning kubespray repository..."
      git clone https://github.com/kubernetes-sigs/kubespray.git /home/vagrant/kubespray
      if [ -d "/home/vagrant/kubespray" ]; then
        echo "Kubespray directory created successfully."
      else
        echo "Failed to create kubespray directory."
        exit 1
      fi
      cd /home/vagrant/kubespray
      echo "Installing kubespray requirements..."
      pip3 install -r requirements.txt
      echo "Initial provisioning script completed."
    SHELL
  end

  # Define the worker nodes
  (1..NODES).each do |i|
    config.vm.define "node-#{i}" do |node|
      node.vm.hostname = "node-#{i}"
      node.vm.network "private_network", ip: "192.168.56.#{10+i}"
      
      node.vm.provision "shell", inline: <<-SHELL
        sudo apt-get update
        sudo apt-get install -y python3-pip
      SHELL
    end
  end

  # Provision Kubespray on the master node after all nodes are up
  config.vm.provision "shell", privileged: true, run: "always", inline: <<-SHELL
    if [[ $(hostname) == "master" ]]; then
      if [ -d "/home/vagrant/kubespray" ]; then
        cd /home/vagrant/kubespray
        cp -rfp inventory/sample inventory/mycluster
        declare -a IPS=("127.0.0.1:2222" "127.0.0.1:2200" "127.0.0.1:2201")
        CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
        ansible-playbook -i inventory/mycluster/hosts.yaml cluster.yml -u vagrant -b
      else
        echo "Kubespray directory not found. Provisioning failed."
        exit 1
      fi
    fi
  SHELL
end
