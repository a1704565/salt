#Vagrantfile - test
#Based on http://terokarvinen.com/2018/automatically-provision-vagrant-virtualmachines-as-salt-slaves

$tscript = <<TSCRIPT
sudo apt-get update
sudo apt-get -y install salt-minion
echo -e 'master: 172.28.171.21\nid: vagrant001'|sudo tee /etc/salt/minion
sudo systemctl restart salt-minion.service
TSCRIPT

Vagrant.configure("2") do |config|
 config.vm.box = "bento/ubuntu-16.04"
 config.vm.provision "shell", inline: $tscript
end
