# Loads a certificate into an NSS database.
#
# Parameters:
#   $certdir   - required - defaults to $title
#   $cert      - required - path to certificate in PEM format
#   $nickname  - optional - the nickname for the NSS certificate
#   $trustargs - optional - defaults to 'CT,,'
#
# Actions:
#   loads certificate and key into the NSS database.
#
# Requires:
#   $certdir
#   $cert
#
# Sample Usage:
#
#      nssdb::add_cert { '/tmp/server.crt':
#        nickname => 'GlobalSign Root CA',
#        certdir  => '/etc/pki/foo',
#      }
#
define nssdb::add_cert(
  $certdir,
  $cert,
  $nickname  = $title,
  $trustargs = 'CT,,'
) {
  include nssdb

  exec { "add_cert_${title}":
    path      => ['/usr/bin'],
    command   => "certutil -d ${certdir} -A -n '${nickname}' -t '${trustargs}' -a -i ${cert}",
    unless    => "certutil -d ${certdir} -L -n '${nickname}'",
    logoutput => true,
    require   => [
      Nssdb::Create[$certdir],
      Class['nssdb'],
    ],
  }
}
