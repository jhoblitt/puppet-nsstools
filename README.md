Puppet nsstools Module
======================

[![Build Status](https://travis-ci.org/jhoblitt/puppet-nsstools.png)](https://travis-ci.org/jhoblitt/puppet-nsstools)

#### Table of Contents

1. [Overview](#overview)
2. [Description](#description)
3. [Usage](#usage)
    * [__Security Considerations__](#security-considerations)
    * [Example](#Example)
    * [Classes](#classes)
    * [Types](#types)
    * [Functions](#functions)
4. [Limitations](#limitations)
    * [Tested Platforms](#tested-platforms)
5. [Versioning](#versioning)
6. [Support](#support)
7. [See Also](#see-also)


Overview
--------

Manages NSS certificate databases


Description
-----------

This is a puppet module for the basic management of the certificate database
format that is used by various [Network Security Services
(NSS)](https://developer.mozilla.org/en-US/docs/NSS) libraries and tools. It's
functionality is implemented using the [NSS
Tools](https://developer.mozilla.org/en-US/docs/NSS/tools) and
[OpenSSL](https://www.openssl.org/) packages.

The latter is some what ironically required as although the NSS suite is
intended to be used in place of OpenSSL, it mandates the usage of
[`PKCS#12`](https://en.wikipedia.org/wiki/PKCS_12) format files for certain
operations.  This is unfortunate as it appears to provide no utility for
converting between the ASCII
[`.pem`](https://serverfault.com/questions/9708/what-is-a-pem-file-and-how-does-it-differ-from-other-openssl-generated-key-file)
format popular for X.509 certificates and `PKCS#12`. Thus, OpenSSL is required
for some operations.

At present, it is capable of creating a new certificate "database" comprised of
the `cert8.db`, `key3.db`, and `secmod.db` files. It is also capable of
inserting ASCII `.pem` format X.509 certificates and private keys into a NSS
database.


Usage
-----

## __Security Considerations__

This module creates an on-disk file in the path of the NSS database named
`nss-password.txt`.  This file contains the password used to encrypt private
keys held by the database in _plain txt_.

*Please consider the security implications before using this module.*

## Example

This is an example of setting up 389 Directory Service NSS db with externally
supplied certificates.

```puppet
nsstools::create { '/etc/dirsrv/slapd-ldap1':
  owner          => 'nobody',
  group          => 'nobody',
  mode           => '0660',
  password       => 'example',
  manage_certdir => false,
  enable_fips    => false,
}

nsstools::add_cert_and_key{ 'Server-Cert':
  certdir => '/etc/dirsrv/slapd-ldap1',
  cert    => '/tmp/foo.pem',
  key     => '/tmp/foo.key',
}

nsstools::add_cert { 'AlphaSSL CA':
  certdir => '/etc/dirsrv/slapd-ldap1',
  cert    => '/tmp/alphassl_intermediate.pem',
}

nsstools::add_cert { 'GlobalSign Root CA':
  certdir => '/etc/dirsrv/slapd-ldap1',
  cert    => '/tmp/globalsign_root.pem',
}
```

## Classes

### `nsstools`

This class is required by all of this module's types.  It "owns" installation
of the `nss-tools` package.

```puppet
# defaults
class { 'nsstools':
  require_openssl => true,
}
```

 * `require_openssl`

    `Bool`. Defaults to: `true`

    Enables/disables a requirement dependency being placed on `Class[openssl]`.

## Types

### `create`

Create an empty NSS database with a password file.

```puppet
# defaults
nsstools::create { <title>:
  password       => <password>, # required
  certdir        => <title>, # defaults to $title
  owner          => undef,
  group          => undef,
  mode           => '0600',
  certdir_mode   => '0700',
  manage_certdir => true,
  enable_fips    => false,
}
```

 * `title`

    Used as the default value for the `certdir` parameter.  If `certdir` is not
    set separately the value must pass validation as an absolute file path.

 * `password`

    `String` Required

    Password to set on the database. There are 
    [__Security Considerations__](#security-considerations) to be aware of with
    this parameter.

 * `certdir`

    `String`/absolute path Defaults to: `title`

    Absolute path to the directory to contain the database files.  Please be
    aware that by setting both the `title` and `certdir` parameters it may be
    possible to declare multiple `nsstools::create` resources that point to the
    same set of NSS database files -- care must be taken to avoid such a
    scenario.

 * `owner`

    `String` Defaults to: `undef`

    Sets user ownership of the NSS db files.

 * `group`

    `String` Defaults to: `undef`

    User that owns the NSS db files.

 * `mode`

    `String` Defaults to: `0600`

 * `certdir_mode`

    `String` Defaults to: `0700`

 * `enable_fips`

    `Boolean` Defaults to: `true`

    If `true` enables FIPS compliance mode on the NSS DB.

### `add_cert`

Insert a certificate into an existing NSS database.

```puppet
nsstools::add_cert { <title>:
  certdir  => <certdir>, # required
  cert     => <cert>, # required
  key      => <key>, # required
  nickname => <title> # defaults to $title
}
```

 * `title`

    Used as the default value for the `nickname` parameter.

 * `certdir`

    `String`/absolute path required

    Absolute path to the directory to contain the database files.

 * `cert`

    `String`/absolute path required

    Absolute path to the certificate in `.pem` format to add to the database.

 * `nickname`

    `String` defaults to: `title`

    The "nickname" of the certificate in the database.

 * `trustargs`

    `String` defaults to: `CT,,`

    The certificate trust attributes in the database.

### `add_cert_and_key`

Insert a certificate and it's associated private key an existing NSS database.

```puppet
nsstools::add_cert_and_key { <title>:
  certdir  => <certdir>, # required
  cert     => <cert>, # required
  key      => <key>, # required
  nickname => <title> # defaults to $title
}
```

 * `title`

    Used as the default value for the `nickname` parameter.

 * `certdir`

    `String`/absolute path required

    Absolute path to the directory to contain the database files.

 * `cert`

    `String`/absolute path required

    Absolute path to the certificate in `.pem` format to add to the database.

 * `key`

    `String`/absolute path required

    Absolute path to the private key in `.pem` format (unencrypted) to add to
    the database.

 * `nickname`

    `String` defaults to: `title`

    The "nickname" of the certificate in the database.

## Functions

### `nsstools_add_cert`

Iterates over a hash of cert nickname/path pairs (key/value) and creates
nsstools::add_cert resources.

```puppet
nsstools_add_cert(
  '/etc/dirsrv/slapd-ldap1',
  {
    'AlphaSSL CA'        => '/tmp/alphassl_intermediate.pem',
    'GlobalSign Root CA' => '/tmp/globalsign_root.pem',
  }
)
```

Would effectively define these resources:

```puppet
nsstools::add_cert { 'AlphaSSL CA':
  certdir => '/etc/dirsrv/slapd-ldap1',
  cert    => '/tmp/alphassl_intermediate.pem',
}

nsstools::add_cert { 'GlobalSign Root CA':
  certdir => '/etc/dirsrv/slapd-ldap1',
  cert    => '/tmp/globalsign_root.pem',
}
```


Limitations
-----------

The functionality of this module is rather basic, it does not have facilities
for:

 * Inserting `PKCS#12` files directly (trivial to add)
 * Removal or purging of certificates

At present, only support for `$::osfamily == 'RedHat'` has been implemented.
Adding other Linux distributions and operatingsystems should be trivial.

## Tested Platforms

 * el6.x


Versioning
----------

Please log tickets and issues at
[github](https://github.com/jhoblitt/puppet-nsstools/issues)


See Also
--------

 * [Network Security Services (NSS)](https://developer.mozilla.org/en-US/docs/NSS) libraries and tools.
 * [NSS Tools](https://developer.mozilla.org/en-US/docs/NSS/tools)
 * [`certutil`](https://developer.mozilla.org/en-US/docs/NSS/tools/NSS_Tools_certutil)
 * [`PKCS#12`](https://en.wikipedia.org/wiki/PKCS_12)
 * [`pk12util`](https://developer.mozilla.org/en-US/docs/NSS/tools/NSS_Tools_pk12util)
 * [OpenSSL](https://www.openssl.org/)
 * [`openssl`](https://www.openssl.org/docs/apps/openssl.html)
