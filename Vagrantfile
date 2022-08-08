Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.box_version = "20220724.0.0"

  config.vm.network "private_network", ip: "192.168.56.202"

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    bash /vagrant/script/1-netplan.sh
    bash /vagrant/script/2-base.sh
    bash /vagrant/script/3-kubeadm.sh
    bash /vagrant/script/4-kubernetes.sh
    bash /vagrant/script/5-free5gc.sh
    bash /vagrant/script/6-subscribe.sh
    bash /vagrant/script/7-ueransim.sh
  SHELL
end
