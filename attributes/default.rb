default['nginx']['sites'] = {}
default['apache']['sites'] = {}

default['ssl_certs'] = {}
default['skip_ssl_write'] = false

default['nginx']['https_variable_emulation'] = true

protocols = {
  'nginx' => 'TLSv1 TLSv1.1 TLSv1.2',
  'apache' => 'All -SSLv2 -SSLv3'
}

['apache', 'nginx'].each do |type|
  site = node.default["#{type}-sites"]

  site['secure_port'] = 443
  site['insecure_port'] = 80
  site['endpoint'] = 'index.php'
  site['php_support'] = true
  site['realpath_document_root'] = false
  site['php-fpm']['host'] = '127.0.0.1'
  site['php-fpm']['port'] = 9000
  site['php-fpm']['socket'] = '/var/run/php-fpm-www.sock'
  site['php-fpm']['listen'] = 'socket'
  site['ssl']['certfile'] = '/etc/pki/tls/certs/cert.pem'
  site['ssl']['keyfile'] = '/etc/pki/tls/private/key.pem'
  site['ssl']['protocols'] = protocols[type]
  site['ssl']['ciphersuite'] = 'EECDH+AESGCM:EDH+AESGCM:ECDHE-RSA-AES128-GCM-SHA256:AES256+EECDH:DHE-RSA-AES128-GCM-SHA256:AES256+EDH:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA:DES-CBC3-SHA:HIGH:!aNULL:!eNULL:!EXPORT:!DES:!MD5:!PSK:!RC4;'
  site['ssl']['cacertfile'] = nil
  site['ssl']['certchainfile'] = nil
  site['skip_ssl_write'] = default['skip_ssl_write']
  site['template'] = "#{type}_site.conf.erb"
  site['cookbook'] = 'config-driven-helper'
  site['protocols'] = ['http']
  site['server_type'] = type
  site['disable_default_location_block'] = false
end

default['iptables-standard']['allowed_incoming_ports'] = {
  "ssh" => "ssh"
}

default['mysql']['connections']['default'] = {
  :username => "root",
  :password => node["mysql"]["server_root_password"],
  :host => "localhost"
}
