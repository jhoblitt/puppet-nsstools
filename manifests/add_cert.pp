# Loads a certificate into an NSS database.
#
# Parameters:
#   $certdir         - required - defaults to $title
#   $cert            - required - path to certificate in PEM format
#   $nickname        - optional - the nickname for the NSS certificate
#   $trustargs       - optional - defaults to 'CT,,'
#   $certdir_managed - optional - is certdir managed by this module. Defaults to true
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
#   nsstools::add_cert { '/tmp/server.crt':
#     nickname => 'GlobalSign Root CA',
#     certdir  => '/etc/pki/foo',
#   }
#
#
define nsstools::add_cert(
  $certdir,
  $cert,
  $nickname  = $title,
  $trustargs = 'CT,,',
  Boolean $certdir_managed = true,
) {
  include nsstools

  validate_absolute_path($certdir)
  validate_absolute_path($cert)
  validate_string($nickname)
  validate_string($trustargs)

  exec { "add_cert_${title}":
    path      => ['/usr/bin'],
    command   => "certutil -d ${certdir} -A -n '${nickname}' -t '${trustargs}' -a -i ${cert}",
    unless    => "certutil -d ${certdir} -L -n '${nickname}'",
    logoutput => true,
    require   => [
      Class['nsstools'],
    ],
  }

  if ($certdir_managed == true) {
    Nsstools::Create[$certdir]
    -> Exec["add_cert_${title}"]
  }
}
