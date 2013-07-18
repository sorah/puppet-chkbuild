class chkbuild::nginx($server_name) {
  include nginx

  file { '/etc/nginx/sites/chkbuild':
    content => template('chkbuild/nginx'),
    owner => 'root',
    group => 'root',
    mode => 644,
    require => File['/etc/nginx']
  }
}
