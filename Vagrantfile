# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX_NAME = ENV['BOX_NAME'] || "ubuntu"
BOX_URI = ENV['BOX_URI'] || "http://files.vagrantup.com/precise64.box"
VF_BOX_URI = ENV['BOX_URI'] || "http://files.vagrantup.com/precise64_vmware_fusion.box"
AWS_REGION = ENV['AWS_REGION']
AWS_AMI    = ENV['AWS_AMI']

Vagrant::Config.run do |config|
  # Setup virtual machine box. This VM configuration code is always executed.
  config.vm.box = BOX_NAME
  config.vm.box_url = BOX_URI

  #Shipyard
  config.vm.forward_port 8005, 8005
  #redis
  config.vm.forward_port 6379, 6379

  #elasticsearch
  config.vm.forward_port 9200, 9200
  config.vm.forward_port 9300, 9300

  #cassandra
  config.vm.forward_port 7000, 7000
  config.vm.forward_port 7001, 7001
  config.vm.forward_port 7199, 7199
  config.vm.forward_port 9160, 9160
  config.vm.forward_port 9042, 9042

  #mongo
  config.vm.forward_port 27017, 27017
  config.vm.forward_port 28017, 28017

  #kafka
  config.vm.forward_port 9092, 9092
  config.vm.forward_port 7203, 7203

  #zookeeper
  config.vm.forward_port 2181, 2181

  #jetty
  config.vm.forward_port 8080, 8080

  #Storm UI
  config.vm.forward_port 8081, 8081

  # riemann
  config.vm.forward_port 5555, 5555, protocol: 'tcp'
  config.vm.forward_port 5555, 5555, protocol: 'udp'
  config.vm.forward_port 5556, 5556
  config.vm.forward_port 5557, 5557
  config.vm.forward_port 4567, 4567

  # Provision docker and new kernel if deployment was not done.
  # It is assumed Vagrant can successfully launch the provider instance.
  if Dir.glob("#{File.dirname(__FILE__)}/.vagrant/machines/default/*/id").empty?
    # Add lxc-docker package
    pkg_cmd = "wget -q -O - https://get.docker.io/gpg | apt-key add -;" \
      "echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list;" \
      "apt-get update -qq; apt-get install -q -y --force-yes lxc-docker; "
    # Add Ubuntu raring backported kernel
    pkg_cmd << "apt-get update -qq; apt-get install -q -y linux-image-generic-lts-raring; "
    # Add guest additions if local vbox VM. As virtualbox is the default provider,
    # it is assumed it won't be explicitly stated.
    if ENV["VAGRANT_DEFAULT_PROVIDER"].nil? && ARGV.none? { |arg| arg.downcase.start_with?("--provider") }
      pkg_cmd << "apt-get install -q -y linux-headers-generic-lts-raring dkms; " \
        "echo 'Downloading VBox Guest Additions...'; " \
        "wget -q http://dlc.sun.com.edgesuite.net/virtualbox/4.2.12/VBoxGuestAdditions_4.2.12.iso; "
      # Prepare the VM to add guest additions after reboot
      pkg_cmd << "echo -e 'mount -o loop,ro /home/vagrant/VBoxGuestAdditions_4.2.12.iso /mnt\n" \
        "echo yes | /mnt/VBoxLinuxAdditions.run\numount /mnt\n" \
          "rm /root/guest_additions.sh; ' > /root/guest_additions.sh; " \
        "chmod 700 /root/guest_additions.sh; " \
        "sed -i -E 's#^exit 0#[ -x /root/guest_additions.sh ] \\&\\& /root/guest_additions.sh#' /etc/rc.local; " \
        "echo 'Installation of VBox Guest Additions is proceeding in the background.'; " \
        "echo '\"vagrant reload\" can be used in about 2 minutes to activate the new guest additions.'; "
    end
    # Activate new kernel
    pkg_cmd << "shutdown -r +1; "
    config.vm.provision :shell, :inline => pkg_cmd
  end
end


# Providers were added on Vagrant >= 1.1.0
Vagrant::VERSION >= "1.1.0" and Vagrant.configure("2") do |config|
  config.vm.provider :aws do |aws, override|
    aws.access_key_id = ENV["AWS_ACCESS_KEY_ID"]
    aws.secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"]
    aws.keypair_name = ENV["AWS_KEYPAIR_NAME"]
    override.ssh.private_key_path = ENV["AWS_SSH_PRIVKEY"]
    override.ssh.username = "ubuntu"
    aws.region = AWS_REGION
    aws.ami    = AWS_AMI
    aws.instance_type = "m1.xlarge"
  end

  config.vm.provider :rackspace do |rs|
    config.ssh.private_key_path = ENV["RS_PRIVATE_KEY"]
    rs.username = ENV["RS_USERNAME"]
    rs.api_key  = ENV["RS_API_KEY"]
    rs.public_key_path = ENV["RS_PUBLIC_KEY"]
    rs.flavor   = /512MB/
    rs.image    = /Ubuntu/
  end

  config.vm.provider :vmware_fusion do |f, override|
    override.vm.box = BOX_NAME
    override.vm.box_url = VF_BOX_URI
    #override.vm.synced_folder ".", "/vagrant", disabled: true
    f.vmx["displayName"] = "docker"
  end

  config.vm.provider :virtualbox do |vb|
    config.vm.box = BOX_NAME
    config.vm.box_url = BOX_URI
    #memory
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end
end



