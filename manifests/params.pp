# this class should be considered private
class nsstools::params {
  $password_file_name = 'nss-password.txt'

  case $facts['os']['family'] {
    'redhat': {
      $package_name = ['nss-tools']
    }
    default: {
      fail("Module ${module_name} is not supported on ${facts['os']['family']}")
    }
  }
}
