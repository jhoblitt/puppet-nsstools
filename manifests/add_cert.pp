# Loads a certificate into an NSS database.
#
# Parameters:
#   $nickname         - required - the nickname for the NSS certificate
#   $cert             - required - path to certificate in PEM format
#   $certdir          - optional - defaults to $title
#   $trustargs        - optional - defaults to 'CT,,'
#
# Actions:
#   loads certificate and key into the NSS database.
#
# Requires:
#   $nickname
#   $cert
#
# Sample Usage:
#
#      nssdb::add_cert { '/etc/pki/foo':
#        nickname => 'GlobalSign Root CA',
#        cert     => '/tmp/server.crt',
#      }
#
define nssdb::add_cert(
  $nickname,
  $cert,
  $certdir   = $title,
  $trustargs = 'CT,,'
) {
  include nssdb

  exec { "add_cert_${title}":
    path      => ['/usr/bin'],
    command   => "certutil -d ${certdir} -A -n '${nickname}' -t '${trustargs}' -a -i ${cert}",
    unless    => "certutil -d ${certdir} -L -n '${nickname}'",
    logoutput => true,
    require   => [
      Class['nssdb'],
    ],
  }
}
