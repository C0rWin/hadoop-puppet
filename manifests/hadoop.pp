class hadoop_vm {
        
    host { 'fileserver': 
        ip => "10.17.3.7"
    }

    host { 'hadoop_master':
        ip => '10.17.3.10'
    }

    host { 'hadoop_slave':
        ip => '10.17.3.12'
    }
    exec { 'apt-get update':
        command => '/usr/bin/apt-get update',
        timeout => 36000,
    }

    exec {  'apt-get upgrade':
        command => '/bin/echo dummy',
        require => Exec['apt-get update'],
        timeout => 36000,
    }

    package { 'nginx':
        ensure => present,
        require => Exec['apt-get upgrade'],
    }

    package {
        [ 'git-core', 'zsh', 'vim', 'htop', 'ruby-rvm', 'rubygems']: 
        ensure => present,
        require => Exec['apt-get upgrade'],
    }

    package {
        [ 'fpm']:
        ensure => present,
        provider => 'gem',
        require => Package[ 'rubygems']
    }

    exec { 'oh-my-zsh':
        command => '/usr/bin/git clone https://github.com/robbyrussell/oh-my-zsh.git /home/vagrant/.oh-my-zsh',
        require => Package['zsh', 'git-core'],
        user => 'vagrant',
        creates => '/home/vagrant/.oh-my-zsh',
        logoutput => true,
    }

    service { 'nginx':
        ensure => running,
        require => Package['nginx'],
    }

    /* user { 'vagrant':
        ensure => 'present',
        shell => '/bin/zsh',
        managehome => true,
    } */

    exec { 'zshrc':
        command => '/bin/ln -s /vagrant/config/.zshrc /home/vagrant/.zshrc',
        user => 'vagrant',
        creates => '/home/vagrant/.zshrc',
    }

    exec { 'vimrc':
        command => '/bin/ln -s /vagrant/config/.vimrc /home/vagrant/.vimrc',
        user => 'vagrant',
        creates => '/home/vagrant/.vimrc',
    }

}


include hadoop_vm

class { "hadoop":
    masterNode => "10.17.3.10",
    slaveNodes => ["10.17.3.10", "10.17.3.12"],
    distrFile  => "hadoop-1.2.1",
    hadoopHome => "/home/vagrant/hadoop"
}

include java
include maven
