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
#     nsstools::add_cert_and_key{ 'Server-Cert':
#       certdir => '/dne',
#       cert    => '/tmp/server.crt',
#       key     => '/tmp/server.key',
#     }
#
define nsstools::add_cert_and_key (
  $certdir,
  $cert,
  $key,
  $nickname = $title
) {
  include nsstools

  # downcase and change spaces into _s
  $pkcs12_name = downcase(regsubst("${nickname}.p12", '[\s]', '_', 'GM'))

  # the exec type in older versions of puppet don't support the umask param so
  # we have to inline it in the command string
  exec {"generate_pkcs12_${title}":
    command   => "umask 7077 && /usr/bin/openssl pkcs12 -export -in ${cert} -inkey ${key} -password 'file:${certdir}/nss-password.txt' -out '${certdir}/${pkcs12_name}' -name '${nickname}'",
    creates   => "${certdir}/${pkcs12_name}",
    subscribe => File["${certdir}/nss-password.txt"],
    require   => [
      Nsstools::Create[$certdir],
      Class['nsstools'],
    ],
  }

  exec { "add_pkcs12_${title}":
    path      => ['/usr/bin'],
    command   => "pk12util -d ${certdir} -i ${certdir}/${pkcs12_name} -w ${certdir}/nss-password.txt -k ${certdir}/nss-password.txt",
    unless    => "certutil -d ${certdir} -L -n '${nickname}'",
    logoutput => true,
    require   => [
      Exec["generate_pkcs12_${title}"],
      Nsstools::Create[$certdir],
      Class['nsstools'],
    ],
  }

}
