# Creates a self signed certificate with key directly in the NSS database.
#
# Parameters:
#   $nickname  - optional - The nickname for the NSS certificate, defaults to the title
#   $subject   - required - The subject of the certificate.
#                           The subject identification format follows RFC #1485.
#   $keytype   - optional - The type of key to generate with the self signed cert.
#                           Valid options: ras|dsa|ec|all
#   $noisefile - optional - The path to a file to use as noise to generate the cert.
#                           The minimum file size is 20 bytes.
#   $certdir   - required - The path to the NSS DB to add the cert to
#
# Actions:
#  Creates a self signed certifacate directly in the NSS databae.
#
# Requires:
#   $subject
#   $certdir
#
# Sample Usage:
#
#   nsstools::create_cert_and_key { 'server_cert':
#     nickname => 'Servert Cert',
#     subject  => 'CN=localhost, OU=OrgUnit, O=Org, L=City, ST=State, C=MY\',
#     certdir  => '/etc/pki/foo',
#   }
#
define nsstools::create_cert_and_key(
  $nickname  = $title,
  $subject,
  $keytype   = 'rsa',
  $noisefile = '/var/log/messages',
  $certdir,
) {
  include nsstools
  include nsstools::params

  validate_string($nickname)
  validate_string($subject)
  validate_re($keytype, [ '^rsa', '^dsa', '^ec', '^all' ])
  validate_absolute_path($certdir)
  validate_absolute_path($noisefile)

  $_password_file = "${certdir}/${nsstools::params::password_file_name}"

  # create the cert and key in the NSS database
  exec { "create_cert_and_key_${title}":
    path      => ['/usr/bin'],
    command   => "certutil -S -k ${keytype} -n '${nickname}' -t \"u,u,u\" -x -s \"${subject}\" -d ${certdir} -f ${_password_file} -z ${noisefile}",
    unless    => "certutil -d ${certdir} -L -n '${nickname}'",
    logoutput => true,
    require   => [
      Nsstools::Create[$certdir],
      File[$_password_file],
      Class['nsstools'],
    ],
  }
}
