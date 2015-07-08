# vagrant init precise64 http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "puppetlabs/ubuntu-14.04-64-puppet"

  config.vm.synced_folder ".", "/etc/puppet/modules/ohmyzsh"

  config.vm.provision :shell, inline: <<-EOF
    gem install rspec-puppet --no-user-install --no-ri --no-rdoc
    gem install puppetlabs_spec_helper --no-user-install --no-ri --no-rdoc
    apt-get update
    puppet module install puppetlabs/stdlib
  EOF

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "tests"
    puppet.manifest_file  = "vagrant.pp"
    puppet.options        = "../"
    puppet.options        = "--verbose --debug"
  end

  config.vm.provision :serverspec do |spec|
    spec.pattern = 'spec/*_spec.rb'
  end

end
