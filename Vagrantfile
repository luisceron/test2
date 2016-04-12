Vagrant.configure(2) do |config|
  # Box
  config.vm.box = "ubuntu/trusty64"
  # Development
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  # MailCatcher
  config.vm.network "forwarded_port", guest: 1080, host: 1080
  # Static IP
  config.vm.network "private_network", ip: "192.168.10.86"
  # Integration with PGAdmin
  config.vm.network "forwarded_port", guest: 5432, host: 5433
  # Setup
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end
end
