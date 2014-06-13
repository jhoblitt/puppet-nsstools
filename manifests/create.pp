# Create an empty NSS database with a password file.
#
# Parameters:
#   $password       - required - password to set on the database
#   $certdir        - optional - defaults to title
#   $owner          - optional - the file/directory user
#   $group          - optional - the file/directory group
#   $mode           - optional - defaults to '0600'
#   $certdir_mode   - optional - defaults to '0700'
#   $manage_certdir - optional - defaults to true
#   $enable_fips    - optional - defaults to false
#
# Actions:
#   creates a new NSS database, consisting of 4 files:
#      cert8.db, key3.db, secmod.db and a password file, nss-password.txt
#
# Requires:
#   $password must be set
#
# Sample Usage:
#
#   nsstools::create { '/tmp/mydb':
#     password       => 'password',
#     certdir        => '/tmp/mydb', # defaults to $title
#     owner          => 'root',
#     group          => 'root',
#     mode           => '0600',
#     certdir_mode   => '0700',
#     manage_certdir => true,
#     enable_fips    => false,
#   }
#
#
define nsstools::create (
  $password,
  $certdir        = $title,
  $owner          = undef,
  $group          = undef,
  $mode           = '0600',
  $certdir_mode   = '0700',
  $manage_certdir = true,
  $enable_fips    = false,
) {
  include nsstools
  include nsstools::params

  validate_string($password)
  validate_absolute_path($certdir)
  validate_string($owner)
  validate_string($group)
  validate_string($mode)
  validate_string($certdir_mode)
  validate_bool($manage_certdir)
  validate_bool($enable_fips)

  if $manage_certdir {
    file { $certdir:
      ensure => directory,
      owner  => $owner,
      group  => $group,
      mode   => $certdir_mode,
    }

    $require_certdir = File[$certdir]

  } else {
    $require_certdir = undef
  }

  $_password_file = "${certdir}/${nsstools::params::password_file_name}"
  file { $_password_file:
    ensure  => file,
    owner   => $owner,
    group   => $group,
    content => $password,
    mode    => $mode,
    require => $require_certdir,
  }

  file { [
    "${certdir}/cert8.db",
    "${certdir}/key3.db",
    "${certdir}/secmod.db"
  ]:
    ensure  => file,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    require => [
      File[$_password_file],
      Exec["create_nss_db_${title}"],
    ],
  }

  exec { "create_nss_db_${title}":
    command => "/usr/bin/certutil -N -d ${certdir} -f ${_password_file}",
    creates => ["${certdir}/cert8.db", "${certdir}/key3.db", "${certdir}/secmod.db"],
    require => [
      File[$_password_file],
      Class['nsstools'],
    ]
  }

  if $enable_fips {
    # enable fips mode on the NSS DB after DB creation
    exec { "enable_fips_mode_${title}":
      command     => "/usr/bin/modutil -fips true -dbdir ${certdir} -force",
      unless      => "/usr/bin/modutil -chkfips true -dbdir ${certdir}",
      subscribe   => [Exec["create_nss_db_${title}"],],
      refreshonly => true,
    }
  }
}
