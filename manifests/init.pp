class spark {

  require wget

  $version = 'spark-0.9.0-incubating-bin-hadoop2'

  file { "/tmp/spark-${version}.tgz":
    ensure => present,
    require => Exec['Fetch spark'],
  }

  exec { 'Fetch spark':
    cwd => '/tmp',
    command => "wget http://d3kbcqa49mib13.cloudfront.net/${version}.tgz",
    creates => "/tmp/${version}.tgz",
    path    => ['/opt/boxen/homebrew/bin'],
    require => File['/usr/local'];
  }

  exec { 'Extract spark':
    cwd     => '/usr/local',
    command => "tar xvf /tmp/scala-${version}.tgz",
    creates => "/usr/local/${version}",
    path    => ['/usr/bin'],
    require => Exec['Fetch spark'];
  }

  file { "/usr/local/${version}":
    require => Exec['Extract spark'];
  }

  file { '/usr/local/spark':
    ensure  => link,
    target  => "/usr/local/${version}",
    require => File["/usr/local/${version}"];
  }

  file { '/opt/boxen/bin/pyspark':
    ensure => link,
    target  => '/usr/local/spark/bin/pyspark',
    require => File['/usr/local/spark'];
  }

  file { '/opt/boxen/bin/spark-shell':
    ensure => link,
    target  => '/usr/local/spark/bin/spark-shell',
    require => File['/usr/local/spark-shell'];
  }

}