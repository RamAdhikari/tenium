# == Class: tanium
#
# Full description of class tanium here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'tanium':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class tanium (

  $servername        = $tanium::params::severname,         # Tanium server (required)
  $serverport        = $tanium::params::serverport,
  $resolver          = $tanium::params::resolver,
  $version           = $tanium::params::version,
  $servernamelist    = $tanium::params::servernamelist,
  $databaseepoch     = $tanium::params::databaseepoch,
  $computerid        = $tanium::params::computerid,
  $logpath           = $tanium::params::logpath,
  $logsize           = $tanium::params::logsize,
  $logverbositylevel = $tanium::params::logverbositylevel,
  
  $service_enable    = $tanium::params::service_enable,
  $service_ensure    = $tanium::params::service_ensure,
  $service_name      = $tanium::params::service_name,

  $package_name      = $tanium::params::package_name,
  $package_ensure    = $tanium::params::package_ensure,

  $ini_owner         = $tanium::params::ini_owner,
  $ini_group         = $tanium::params::ini_group,
  $ini_mode          = $tanium::params::ini_mode,

  $pub_key           = $tanium::params::pub_key,


) inherits tanium::params {

  # TODO:  Add OSX resolver options "gethostbyname" and "getaddrinfo".
  validate_re($resolver, '^(getent|getenta|host|nslookup|dig|res_search)$', "ssh::sshd_config_strictmodes may be either 'yes' or 'no' and is set to <${sshd_config_strictmodes}>.")

  if is_integer($serverport) == false { fail("tanium::serverport must be an integer but it is set to <${serverport}>.") }
  if is_integer($logverbositylevel) == false { fail("tanium::logverbositylevel must be an integer but it is set to <${logverbositylevel}>.") }
  if is_integer($logsize) == false { fail("tanium::logsize must be an integer but it is set to <${logsize}>.") }

  validate_absolute_path($logpath)


  service{$service_name:
    ensure => $service_ensure,
    enable => $service_enable,
  }

  file{$tanium::params::ini_file:
    ensure => file,
    owner  => $ini_owner,
    group  => $ini_group,
    mode   => $ini_mode,
    content => template('tanium/TaniumClient.ini.erb'),
    notify => Service[$service_name];

  $logpath:
    ensure => directory,
    owner  => $ini_owner,
    group  => $ini_group,
    mode   => $ini_mode;

  $pub_key:
    ensure => file,
    owner  => $ini_owner,
    group  => $ini_group,
    mode   => $ini_mode,
    source => 'puppet:///modules/tanium/tanium.pub',
  }

  package {$package_name:
    ensure => $package_ensure,
    before => [ File[$logpath], File[$pub_key], ],
  }

}
