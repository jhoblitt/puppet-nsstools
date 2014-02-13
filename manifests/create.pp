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
#     manage_certdir => true
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
  $manage_certdir = true
) {
  include nsstools

  validate_string($password)
  validate_absolute_path($certdir)
  validate_string($owner)
  validate_string($group)
  validate_string($mode)
  validate_string($certdir_mode)
  validate_bool($manage_certdir)

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

  file { "${certdir}/nss-password.txt":
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
      File["${certdir}/nss-password.txt"],
      Exec["create_nss_db_${title}"],
    ],
  }

  exec { "create_nss_db_${title}":
    command => "/usr/bin/certutil -N -d ${certdir} -f ${certdir}/nss-password.txt",
    creates => ["${certdir}/cert8.db", "${certdir}/key3.db", "${certdir}/secmod.db"],
    require => [
      File["${certdir}/nss-password.txt"],
      Class['nsstools'],
    ]
  }
}
