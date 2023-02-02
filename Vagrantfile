Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.box_version = "20230128.0.0"

  config.vm.network "private_network", ip: "192.168.56.202"

  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 4
    vb.memory = 8192
  end

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    bash -eu /vagrant/script/1-netplan.sh
    bash -eu /vagrant/script/2-base.sh
    sudo snap install yq
    curl -fsSL https://raw.githubusercontent.com/hi120ki/vagrant-k8s-flannel/main/install.sh | bash -eu -s -- 192.168.56.202
    bash -eu /vagrant/script/4-multus.sh
    bash -eu /vagrant/script/5-free5gc.sh
    bash -eu /vagrant/script/6-subscribe.sh
    bash -eu /vagrant/script/7-ueransim.sh
  SHELL
end
