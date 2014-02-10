# Loads a certificate and key into an NSS database.
#
# Parameters:
#   $certdir  - required - defaults to $title
#   $cert     - required - path to certificate in PEM format
#   $key      - required - path to unencrypted key in PEM format
#   $nickname - optional - the nickname for the NSS certificate
#
# Actions:
#   loads certificate and key into the NSS database.
#
# Requires:
#   $certdir
#   $cert
#   $key
#
# Sample Usage:
#
#     nssdb::add_cert_and_key{ 'Server-Cert':
#       certdir => '/dne',
#       cert    => '/tmp/server.crt',
#       key     => '/tmp/server.key',
#     }
#
define nssdb::add_cert_and_key (
  $certdir,
  $cert,
  $key,
  $nickname = $title
) {
  include nssdb

  # downcase and change spaces into _s
  $pkcs12_name = downcase(regsubst("${nickname}.p12", '[\s]', '_', 'GM'))

  exec {"generate_pkcs12_${title}":
    umask     => '7077',
    command   => "/usr/bin/openssl pkcs12 -export -in ${cert} -inkey ${key} -password 'file:${certdir}/nss-password.txt' -out '${certdir}/${pkcs12_name}' -name '${nickname}'",
    creates   => "${certdir}/${pkcs12_name}",
    subscribe => File["${certdir}/nss-password.txt"],
    require   => [
      Nssdb::Create[$certdir],
      Class['nssdb'],
    ],
  }

  exec { "add_pkcs12_${title}":
    path      => ['/usr/bin'],
    command   => "pk12util -d ${certdir} -i ${certdir}/${pkcs12_name} -w ${certdir}/nss-password.txt -k ${certdir}/nss-password.txt",
    unless    => "certutil -d ${certdir} -L -n '${nickname}'",
    logoutput => true,
    require   => [
      Exec["generate_pkcs12_${title}"],
      Nssdb::Create[$certdir],
      Class['nssdb'],
    ],
  }

}
