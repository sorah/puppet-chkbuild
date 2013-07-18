class chkbuild($top_uri, $hour = '*/8', $minute = '0', $month = '*', $monthday = '*', $weekday = '*') {
  user { 'chkbuild':
    home => '/home/chkbuild',
    managehome => false,
    system => true,
  }

  file { '/home/chkbuild':
    ensure => directory,
    mode => 2755,
    owner => 'chkbuild',
    group => 'chkbuild',
    require => User['chkbuild']
  }

  file { '/home/chkbuild/build':
    ensure => directory,
    mode => 2775,
    owner => 'chkbuild',
    group => 'chkbuild',
    require => File['/home/chkbuild']
  }

  file { '/home/chkbuild/public_html':
    ensure => directory,
    mode => 2775,
    owner => 'chkbuild',
    group => 'chkbuild',
    require => File['/home/chkbuild']
  }

  file { '/opt/chkbuild/tmp':
    ensure => link,
    target => '/home/chkbuild',
    owner => 'root',
    group => 'root',
    require => [File['/home/chkbuild'], Exec['chkbuild-install']]
  }

  exec { 'chkbuild-install':
    command => 'mkdir -p /opt; git clone https://github.com/akr/chkbuild.git /opt/chkbuild',
    unless  => 'test -d /opt/chkbuild',
    require => File['/home/chkbuild'],
  }

  file { '/opt/chkbuild/run':
    ensure => file,
    mode => 755,
    owner => 'root',
    group => 'root',
    content => template('chkbuild/build-ruby'),
    require => Exec['chkbuild-install']
  }

  cron { 'chkbuild':
    command => "cd /opt/chkbuild; sudo -u chkbuild /opt/chkbuild/run",
    user => 'root',
    require => File['/opt/chkbuild/run'],
    hour => $hour,
    minute => $minute,
    month => $month,
    monthday => $monthday,
    weekday => $weekday,
  }
}
