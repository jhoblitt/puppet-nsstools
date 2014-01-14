# utility class
class nssdb {
  include nssdb::params

  ensure_packages($::nssdb::params::package_name)

  anchor{ 'nssdb::begin': } ->
  Package[$::nssdb::params::package_name] ->
  anchor{ 'nssdb::end': }
}
