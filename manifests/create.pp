# Create an empty NSS database with a password file.
#
# Parameters:
#   $owner_id         - required - the file/directory user
#   $group_id         - required - the file/directory group
#   $password         - required - password to set on the database
#   $mode             - optional - defaults to '0600'
#   $certdir_mode     - optional - defaults to '0700'
#
# Actions:
#   creates a new NSS database, consisting of 4 files:
#      cert8.db, key3.db, secmod.db and a password file, password.conf
#
# Requires:
#   $owner_id must be set
#   $group_id must be set
#   $password must be set
#
# Sample Usage:
#
# nssdb::create {'test':
#    owner_id => 'qpidd',
#    group_id => 'qpidd',
#    password => 'test'}
#
# This will create an NSS database in /etc/pki/test
#
define nssdb::create (
  $owner_id,
  $group_id,
  $password,
  $mode           = '0600',
  $certdir_mode   = '0700',
  $manage_certdir = true
) {
  include nssdb

  validate_absolute_path($title)
  $certdir = $title

  if $manage_certdir {
    file { $certdir:
      ensure  => directory,
      mode    => $certdir_mode,
      owner   => $owner_id,
      group   => $group_id,
    }

    $require_certdir = File[$certdir]

  } else {
    $require_certdir = undef
  }

  file { "${certdir}/password.conf":
    ensure  => file,
    mode    => $mode,
    owner   => $owner_id,
    group   => $group_id,
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
    owner   => $owner_id,
    group   => $group_id,
    require => [
      File["${certdir}/password.conf"],
      Exec["create_nss_db_${title}"],
    ],
  }

  exec { "create_nss_db_${title}":
    command => "/usr/bin/certutil -N -d ${certdir} -f ${certdir}/password.conf",
    creates => ["${certdir}/cert8.db", "${certdir}/key3.db", "${certdir}/secmod.db"],
    require => [
      File["${certdir}/password.conf"],
      Class['nssdb'],
    ]
  }
}
