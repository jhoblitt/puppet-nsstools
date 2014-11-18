# NOTE: This requires that the directory /tmp/nsstools already exists

# Create a test database owned by the user rcrit
nsstools::create { '/tmp/nsstools':
  owner    => 'rcrit',
  group    => 'rcrit',
  password => 'test',
}

# Add a certificate and private key from PEM fiels
nsstools::add_cert_and_key { 'test':
  certdir => '/tmp/nsstools',
  cert    => '/tmp/cert.pem',
  key     => '/tmp/key.pem',
}

# You can confirm that things are loaded properly with:
#
# List the certs:
# certutil -L -d /tmp/nsstools/test
#
# Verify the cert:
# certutil -V -u V -d /tmp/nsstools/test -n test
