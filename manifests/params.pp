# this class should be considered private
class nsstools::params {
  case $::osfamily {
    'redhat': {
      $package_name = ['nss-tools']
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
}
