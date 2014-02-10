# NOTE: This requires that the directory /tmp/nssdb already exists

# Create a test database owned by the user rcrit
nssdb::create { '/tmp/nssdb':
  owner    => 'rcrit',
  group    => 'rcrit',
  password => 'test',
}

# Add a certificate and private key from PEM fiels
nssdb::add_cert_and_key { 'test':
  certdir  => '/tmp/nssdb',
  cert     => '/tmp/cert.pem',
  key      => '/tmp/key.pem',
}

# You can confirm that things are loaded properly with:
#
# List the certs:
# certutil -L -d /tmp/nssdb/test
#
# Verify the cert:
# certutil -V -u V -d /tmp/nssdb/test -n test
