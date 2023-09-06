# utility class
class nsstools (
  Boolean $require_openssl = true,
) {
  include nsstools::params
  stdlib::ensure_packages($::nsstools::params::package_name)

  if $require_openssl {
    include openssl

    Class['openssl'] ->
    Anchor['nsstools::begin']
  }

  anchor{ 'nsstools::begin': } ->
  Package[$::nsstools::params::package_name] ->
  anchor{ 'nsstools::end': }
}
