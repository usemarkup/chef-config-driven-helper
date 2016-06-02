default['nginx']['sites'] = {}
default['apache']['sites'] = {}

default['ssl_certs'] = {}
default['skip_ssl_write'] = false

default['nginx']['https_variable_emulation'] = false

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
  site['ssl']['ciphersuite'] = 'ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS;'
  site['ssl']['cacertfile'] = nil
  site['ssl']['certchainfile'] = nil
  site['skip_ssl_write'] = nil
  site['template'] = "#{type}_site.conf.erb"
  site['cookbook'] = 'config-driven-helper'
  site['protocols'] = ['http']
  site['server_type'] = type
  site['disable_default_location_block'] = false
end

default['iptables-standard']['allowed_incoming_ports'] = {
  "http" => "http",
  "https" => "https",
  "ssh" => "ssh"
}

default['mysql']['connections']['default'] = {
  :username => "root",
  :password => node["mysql"]["server_root_password"],
  :host => "localhost"
}
