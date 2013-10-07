# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.define :fpm do |fpm_config|
        fpm_config.vm.box = "ubuntu"
        #fpm_config.vm.network :bridged, :bridge => "en0: Wi-Fi (AirPort)"
        fpm_config.vm.network :hostonly, "10.17.3.7"
        fpm_config.vm.customize [ "modifyvm", :id, "--memory", "1024"]
        fpm_config.vm.provision :puppet, :facter => { "fqdn" => "c0rwin.vm.net"} do |puppet|
        #fpm_config.vm.provision :puppet do |puppet|
                #puppet.module_path = "/Users/c0rwin/.puppet/modules/"
                puppet.module_path = "modules"
                puppet.manifests_path = "manifests"
                puppet.manifest_file  = "fpm.pp"
        end
  end

  config.vm.define :g4c do |g4c_config|
        g4c_config.vm.box = "ubuntu"
        #g4c_config.vm.network :bridged, :bridge => "en0: Wi-Fi (AirPort)"
        g4c_config.vm.network :bridged
        g4c_config.vm.forward_port 80, 8080
        g4c_config.vm.customize [ "modifyvm", :id, "--memory", "1024"]
        g4c_config.vm.provision :puppet, :facter => { "fqdn" => "c0rwin.vm.net"} do |puppet|
        #g4c_config.vm.provision :puppet do |puppet|
                puppet.module_path = "~/vagrant/manifests/"
                puppet.module_path = "modules"
                puppet.manifests_path = "manifests"
                puppet.manifest_file  = "g4c.pp"
        end
  end

  config.vm.define :hadoop_master do |hadoop_config|
        hadoop_config.vm.box = "ubuntu"
        hadoop_config.vm.network :hostonly, "10.17.3.10"
        hadoop_config.vm.host_name = "master"
        hadoop_config.vm.customize [ "modifyvm", :id, "--memory", "1024"]
        hadoop_config.vm.provision :puppet, :facter => { "fqdn" => "master"} do |puppet|
                puppet.module_path = "modules"
                puppet.manifests_path = "manifests"
                puppet.manifest_file  = "hadoop.pp"
        end
  end

  config.vm.define :hadoop_slave do |hadoop_config|
        hadoop_config.vm.box = "ubuntu"
        hadoop_config.vm.network :hostonly, "10.17.3.12"
        hadoop_config.vm.host_name = "slave"
        hadoop_config.vm.customize [ "modifyvm", :id, "--memory", "1024"]
        hadoop_config.vm.provision :puppet, :facter => { "fqdn" => "slave"} do |puppet|
                puppet.module_path = "modules"
                puppet.manifests_path = "manifests"
                puppet.manifest_file  = "hadoop.pp"
        end
  end
end
