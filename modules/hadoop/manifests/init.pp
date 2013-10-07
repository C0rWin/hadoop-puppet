class hadoop( $masterNode, $slaveNodes, $distrFile, $hadoopHome) {

    Exec {
        path => [ "/usr/bin", "/bin", "/usr/sbin"]
    }

    file { "/tmp/${distrFile}.tar.gz" :
        source => "puppet:///modules/hadoop/${distrFile}.tar.gz",
        owner =>  vagrant,
        mode  => 755,
        ensure => present
    }
    
    exec { "extract distr":
        cwd => "/tmp",
        command => "tar xf ${distrFile}.tar.gz",
        creates => "${hadoopHome}",
        user => vagrant,
        require => File["/tmp/${distrFile}.tar.gz"]
    }
    
    exec { "move distr":
        cwd => "/tmp",
        command => "mv ${distrFile} ${hadoopHome}",
        creates => "${hadoopHome}",
        user => vagrant,
        require => Exec["extract distr"]
    }

    file { "/etc/profile.d/hadoop.sh":
        content => "export HADOOP_PREFIX=\"${hadoopHome}\"
        export PATH=\"\$PATH:\$HADOOP_PREFIX/bin\""
    }

    file { "${hadoopHome}/conf/slaves":
        content => template( "hadoop/slaves.erb"),
        mode => 644,
        owner => vagrant,
        group => vagrant,
        require => Exec[ "move distr"]
    }
    
    file { "${hadoopHome}/conf/masters":
        content => template( "hadoop/masters.erb"),
        mode => 644,
        owner => vagrant,
        group => vagrant,
        require => Exec[ "move distr"]
    }

    file { "${hadoopHome}/conf/core-site.xml":
        content => template( "hadoop/core-site.erb"),
        mode => 644,
        owner => vagrant,
        group => vagrant,
        require => Exec[ "move distr"]
    }

    file { "${hadoopHome}/conf/hdfs-site.xml":
        content => template( "hadoop/hdfs-site.erb"),
        mode => 644,
        owner => vagrant,
        group => vagrant,
        require => Exec[ "move distr"]
    }

    file { "${hadoopHome}/conf/mapred-site.xml":
        content => template( "hadoop/mapred-site.erb"),
        mode => 644,
        owner => vagrant,
        group => vagrant,
        require => Exec[ "move distr"]
    }

    file { "/home/vagrant/.ssh/id_rsa":
        source => "puppet:///modules/hadoop/id_rsa",
        mode => 600,
        owner => vagrant,
        group => vagrant,
    }

    file { "/home/vagrant/.ssh/id_rsa.pub":
        source => "puppet:///modules/hadoop/id_rsa.pub",
        mode => 600,
        owner => vagrant,
        group => vagrant,
    }

    ssh_authorized_key { "ssh_key":
        ensure => "present",
        key => "AAAAB3NzaC1yc2EAAAADAQABAAABAQDpZ7dT5FROj2z0OQjND8dUZ1BdLweIBjm4nsPGKHCehAtGsoNuhWVb41LMUBNCcjR8+RvVArEmAOSmGdZNnwvPmiuY1vIc+SHabtyfXb/ck5yWtXr1iIOoTwBr2m0ypvRVaOPnbMF2YOb6zocdnYOELe03M8gVIYjuN2xdoB5EDbdQNzoStwrypLcqpL0nVzXutJPZ6MH9uPLvVwF7JJJ2f8wEUBBfOtkaA3C2MQEDMBobMvEz8s3ZBvjq+b7DLiijmUAbmWqXEf1QpXHWSUF7P+KQ10B9ujZ+XS554/cAGqdWUtwIubsHauilGrHhkzD5DHnfyTF+fJgLTI8qkQ9D",
        type => "ssh-rsa",
        user => vagrant,
        require => File["/home/vagrant/.ssh/id_rsa.pub"]
    }
}
