# == Class tanium::params
#
# Tanium agent management module parameters file.
#
# === Parameters
#
# [*resourceutilization*]: <string>
#
# === Examples
#
# === Authors
#
# Brian Schonecker <bschonec@gmail.com>
#
# === Copyright
#

class tanium::params {

  $servername        = 'tanium'
  $install_home      = '/opt/Tanium/TaniumClient'
  $ini_file          = "${install_home}/TaniumClient.ini"
  $serverport        = 17472
  $resolver          = 'getent'
  $version           = Undef
  $servernamelist    = []
  $databaseepoch     = Undef
  $computerid        = Undef

  $ini_owner         = 'root'
  $ini_group         = 'root'
  $ini_mode          = '0700'

  $pub_key           = "${install_home}/tanium.pub"

  case $::osfamily {
    'RedHat': {
      $logpath = $install_home
    }

    default: {
      fail('Only Red Hat supported for $::osfamily (so far).')

    } # default
  } # case

  $logsize           = 1048576
  $logverbositylevel = 1

  $service_ensure    = 'running'
  $service_enable    = true
  $package_name      = 'TaniumClient'
  $package_ensure    = present

  case $::lsbmajdistrelease {
    '7':     {$service_name = 'taniumclient'}
    default: {$service_name = 'TaniumClient'}
  }

}
