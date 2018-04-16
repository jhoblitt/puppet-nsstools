# this class should be considered private
class nsstools::params {
  $password_file_name = 'nss-password.txt'

  case $::osfamily {
    'redhat': {
      $package_name = ['nss-tools']
    }
    'debian': {
      $package_name = ['libnss3-tools']
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
}
