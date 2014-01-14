# Loads a certificate and key into an NSS database.
#
# Parameters:
#   $nickname         - required - the nickname for the NSS certificate
#   $cert             - required - path to certificate in PEM format
#   $key              - required - path to unencrypted key in PEM format
#   $certdir          - optional - defaults to $title
#
# Actions:
#   loads certificate and key into the NSS database.
#
# Requires:
#   $nickname
#   $cert
#   $key
#
# Sample Usage:
#
#      nssdb::add_cert_and_key{"qpidd":
#        nickname=> 'Server-Cert',
#        cert => '/tmp/server.crt',
#        key  => '/tmp/server.key',
#      }
#
define nssdb::add_cert_and_key (
  $nickname,
  $cert,
  $key,
  $certdir = $title
) {
  package { 'openssl': ensure => present }

  # downcase and change spaces into _s
  $pkcs12_name = downcase(regsubst("${nickname}.p12", '[\s]', '_', 'GM'))

  exec {'generate_pkcs12':
    command     => "/usr/bin/openssl pkcs12 -export -in ${cert} -inkey ${key} -password 'file:${certdir}/password.conf' -out '${certdir}/${pkcs12_name}' -name '${nickname}'",
    require     => [
      File["${certdir}/password.conf"],
      File["${certdir}/cert8.db"],
      Package['openssl'],
    ],
    before      => Exec['load_pkcs12'],
    notify      => Exec['load_pkcs12'],
    subscribe   => File["${certdir}/password.conf"],
    refreshonly => true,
  }

  exec {'load_pkcs12':
    command     => "/usr/bin/pk12util -i '${certdir}/${pkcs12_name}' -d '${certdir}' -w '${certdir}/password.conf' -k '${certdir}/password.conf'",
    require     => [
      Exec['generate_pkcs12'],
      Package['nss-tools'],
    ],
    refreshonly => true,
  }
}
