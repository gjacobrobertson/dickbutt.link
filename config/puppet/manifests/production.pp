node 'dickbutt.link' {
  include git

  package { 'build-essential':
    ensure => "installed",
  }

  package { 'imagemagick': 
    ensure => "installed",
  }

  class { 'nginx': }

  nginx::resource::upstream { 'dickbutt':
    members => ['localhost:3000'],
  }

  nginx::resource::vhost { 'dickbutt.link':
    proxy => 'http://dickbutt',
  }

  user { 'deploy':
    ensure => "present",
    managehome => "true",
    shell => "/bin/bash",
  }

  ssh_authorized_key { 'deploy key':
    name => 'deploy@dickbutt.link',
    ensure => 'present',
    key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCckqQkoLfnmRTBqTU9i/GWHV49mhp1+Bdpd2I1vjljDp9i9OaH0CAdESu+OTfujS9tMPZH5KOmDfV/RjVZ8r0oB4wI/J2dqBRDKcyUrZRjJnMeAjWdpqm6TaM/2pXHSXrSAtJUkqcRyIkKyrMTY43JUTxZurNXO6+hQ9jfy5ZYQ+LXPaUvpUVKYJb/bdpKQEYpBam+K2IyV7CLsJB/MawVoZbdfGgS3DsQij7ulVFtnx4ySFIEfh4zr+oOhjNV+/cXrhEGUSk4NrQAiyNJg2I2ZInI4X13oTr5pRQktpnABUCemSHockSO0gtsr2kmgRfj2eyzQ9mKQIxY1z6XqlDd',
    type => 'ssh-rsa',
    user => 'deploy',
    require => User['deploy']
  }

  rbenv::install { "deploy" :
    require => [Package['git'], Package['build-essential'], User['deploy']]
  }

  rbenv::compile { "2.1.2":
    user => "deploy"
  }
}