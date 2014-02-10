# utility class
class nssdb (
  $require_openssl = true,
) {
  validate_bool($require_openssl)

  include nssdb::params
  ensure_packages($::nssdb::params::package_name)

  if $require_openssl {
    include openssl

    Class['openssl'] ->
    Anchor['nssdb::begin']
  }

  anchor{ 'nssdb::begin': } ->
  Package[$::nssdb::params::package_name] ->
  anchor{ 'nssdb::end': }
}
