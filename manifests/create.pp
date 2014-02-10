# Create an empty NSS database with a password file.
#
# Parameters:
#   $owner        - required - the file/directory user
#   $group        - required - the file/directory group
#   $password     - required - password to set on the database
#   $certdir      - optional - defaults to title
#   $mode         - optional - defaults to '0600'
#   $certdir_mode - optional - defaults to '0700'
#
# Actions:
#   creates a new NSS database, consisting of 4 files:
#      cert8.db, key3.db, secmod.db and a password file, nss-password.txt
#
# Requires:
#   $owner must be set
#   $group must be set
#   $password must be set
#
# Sample Usage:
#
# nssdb::create {'test':
#    owner => 'qpidd',
#    group => 'qpidd',
#    password => 'test'}
#
# This will create an NSS database in /etc/pki/test
#
define nssdb::create (
  $owner,
  $group,
  $password,
  $certdir        = $title,
  $mode           = '0600',
  $certdir_mode   = '0700',
  $manage_certdir = true
) {
  include nssdb

  validate_absolute_path($certdir)

  if $manage_certdir {
    file { $certdir:
      ensure => directory,
      mode   => $certdir_mode,
      owner  => $owner,
      group  => $group,
    }

    $require_certdir = File[$certdir]

  } else {
    $require_certdir = undef
  }

  file { "${certdir}/nss-password.txt":
    ensure  => file,
    mode    => $mode,
    owner   => $owner,
    group   => $group,
    content => $password,
    require => $require_certdir,
  }

  file { [
    "${certdir}/cert8.db",
    "${certdir}/key3.db",
    "${certdir}/secmod.db"
  ]:
    ensure  => file,
    mode    => $mode,
    owner   => $owner,
    group   => $group,
    require => [
      File["${certdir}/nss-password.txt"],
      Exec["create_nss_db_${title}"],
    ],
  }

  exec { "create_nss_db_${title}":
    command => "/usr/bin/certutil -N -d ${certdir} -f ${certdir}/nss-password.txt",
    creates => ["${certdir}/cert8.db", "${certdir}/key3.db", "${certdir}/secmod.db"],
    require => [
      File["${certdir}/nss-password.txt"],
      Class['nssdb'],
    ]
  }
}
