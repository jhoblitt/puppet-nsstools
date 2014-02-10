# nssdb puppet module

very simple puppet module to create an NSS database and add a certificate
and key via PEM files.

## Example of setting up 389 ds certs

```
nssdb::create { '/etc/dirsrv/slapd-ldap1':
  owner          => 'nobody',
  group          => 'nobody',
  mode           => '0660',
  password       => 'example',
  manage_certdir => false,
}

nssdb::add_cert_and_key{ 'Server-Cert':
  certdir  => '/etc/dirsrv/slapd-ldap1',
  cert     => '/tmp/foo.pem',
  key      => '/tmp/foo.key',
}

nssdb::add_cert { 'AlphaSSL CA':
  certdir  => '/etc/dirsrv/slapd-ldap1',
  cert     => '/tmp/alphassl_intermediate.pem',
}

nssdb::add_cert { 'GlobalSign Root CA':
  certdir  => '/etc/dirsrv/slapd-ldap1',
  cert     => '/tmp/globalsign_root.pem',
}
```
