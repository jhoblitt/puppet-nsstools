# utility class
class nsstools (
  $require_openssl = true,
) {
  validate_bool($require_openssl)

  include nsstools::params
  ensure_packages($::nsstools::params::package_name)

  if $require_openssl {
    include openssl

    Class['openssl'] ->
    Anchor['nsstools::begin']
  }

  anchor{ 'nsstools::begin': } ->
  Package[$::nsstools::params::package_name] ->
  anchor{ 'nsstools::end': }
}
