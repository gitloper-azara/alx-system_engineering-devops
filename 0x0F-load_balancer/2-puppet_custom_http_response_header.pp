# this manifest configures a new Ubuntu machine to create a custom HTTP header response

$nginx_package = 'nginx'
$nginx_service = 'nginx'

# install Nginx package
exec { 'apt-get update':
    command => '/usr/bin/apt-get update',
    path    => ['/usr/bin', '/usr/sbin']
}

package { $nginx_package:
    ensure  => installed,
    require => Exec['apt-get update']
}

# define the path to the configuration file
$config_file = '/etc/nginx/sites-available/default'

# add custom header within configuration file
file_line { custom_header:
    path    => $config_file,
    match   => '^server {',
    line    => '\tadd_header X-Served-By $hostname;',
    after   => 'server_name _;',
    ensure  => present
}

# restart nginx
service {
    ensure  => running,
    enable  => true
}
