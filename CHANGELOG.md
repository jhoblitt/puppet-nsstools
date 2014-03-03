
#### [Current]
 * [05d081a](../../commit/05d081a) - __(Joshua Hoblitt)__ [re]add dep on camptocamp/openssl >= 0.2.0

The 0.2.0 release of camptocamp/openssl fixes the problem 0.1.0 had
with a fixed dep on stdlib = 0.0.1.  It's now safe to declare a dep on
that module without breaking dep resolution.

    https://github.com/camptocamp/puppet-openssl/issues/22

#### v1.0.1
 * [eba140d](../../commit/eba140d) - __(Joshua Hoblitt)__ bump version to v1.0.1
 * [ab70ece](../../commit/ab70ece) - __(Joshua Hoblitt)__ yet another attempt to work around exec umask issues

#### v1.0.0
 * [75e9d57](../../commit/75e9d57) - __(Joshua Hoblitt)__ prepare for v1.0.0 release
 * [7142b86](../../commit/7142b86) - __(Joshua Hoblitt)__ rename CHANGELOG -> CHANGELOG.md
 * [0edbbea](../../commit/0edbbea) - __(Joshua Hoblitt)__ update README ToC
 * [2ecbada](../../commit/2ecbada) - __(Joshua Hoblitt)__ fix README anchors
 * [fe742b4](../../commit/fe742b4) - __(Joshua Hoblitt)__ fix a few README typos + minor formatting
 * [f79fb87](../../commit/f79fb87) - __(Joshua Hoblitt)__ flesh out README
 * [1cd8de4](../../commit/1cd8de4) - __(Joshua Hoblitt)__ add param validation to nsstools::add_cert_and_key
 * [7bb1565](../../commit/7bb1565) - __(Joshua Hoblitt)__ add param validation to nsstools::add_cert
 * [c4d4c89](../../commit/c4d4c89) - __(Joshua Hoblitt)__ change the {user,group} params to nsstools::create

To be optional and and default to `undef`.

 * [8cb0ab0](../../commit/8cb0ab0) - __(Joshua Hoblitt)__ update rspec to work with ruby 1.8.7

The compat issue was merely a dangling comma so this fix is much less
crude than 9fe8511ec88ba6f8c009b9602a63bb4d08a92fef.

 * [5c5c89d](../../commit/5c5c89d) - __(Joshua Hoblitt)__ Revert "update rspec to work with ruby 1.8.7"

This reverts commit 9fe8511ec88ba6f8c009b9602a63bb4d08a92fef.

 * [a931569](../../commit/a931569) - __(Joshua Hoblitt)__ update exec type syntax to work with older puppet versions
 * [9fe8511](../../commit/9fe8511) - __(Joshua Hoblitt)__ update rspec to work with ruby 1.8.7
 * [868d5ae](../../commit/868d5ae) - __(Joshua Hoblitt)__ add .bundle to .gitignore
 * [5e74b6c](../../commit/5e74b6c) - __(Joshua Hoblitt)__ disable Modulefile dep on camptocamp/openssl

Due to a dep on stdlib = 0.0.1:

    https://github.com/camptocamp/puppet-openssl/issues/22

 * [58cf67d](../../commit/58cf67d) - __(Joshua Hoblitt)__ add nsstools_add_cert() function

Imported and renamed the port389_nsstools_add_cert() function from:

    https://github.com/jhoblitt/puppet-port389/tree/93e211f0ef862659523f37ef638f23e127198a94

 * [2030ca5](../../commit/2030ca5) - __(Joshua Hoblitt)__ rename spec files to match module nssdb -> nsstools rename
 * [05c9988](../../commit/05c9988) - __(Joshua Hoblitt)__ suppress lint warnings
 * [c31de09](../../commit/c31de09) - __(Joshua Hoblitt)__ rename module from nssdb -> nsstools

To avoid a namespace conflict with the module this one was initially
forked from and has since become highly diverged.

 * [258a04e](../../commit/258a04e) - __(Joshua Hoblitt)__ do not directly manage openssl package

Add require_openssl param to nssdb class to enable/disable requiring the
`openssl` class.

 * [5f4ea61](../../commit/5f4ea61) - __(Joshua Hoblitt)__ rename password.conf to nss-password.txt

The password.conf name is rather generic and hard to associate with nss
files when the nss db is in a path with other configuration files.

 * [ee1b60e](../../commit/ee1b60e) - __(Joshua Hoblitt)__ change nssdb::add_cert_and_key type to treat it's title as the default nickname

Previously, the title was being used as the default certdir param value.

 * [7ea6c6a](../../commit/7ea6c6a) - __(Joshua Hoblitt)__ update travis matrix
 * [e22a87a](../../commit/e22a87a) - __(Joshua Hoblitt)__ change nssdb::add_cert type to treat it's title as the default nickname

Previously, the title was being used as the default cert param value.

 * [a733330](../../commit/a733330) - __(Joshua Hoblitt)__ add certdir param to nssdb::create type

Defaults to the type's title.

 * [729396f](../../commit/729396f) - __(Joshua Hoblitt)__ modernize Gemfile/Rakefile/spec_helper boilerplate
 * [991b4c7](../../commit/991b4c7) - __(Joshua Hoblitt)__ rename {owner,group}_id params to {owner,group}
 * [1be0034](../../commit/1be0034) - __(Joshua Hoblitt)__ fix multiple nssdb::create declarations
 * [2a212ec](../../commit/2a212ec) - __(Joshua Hoblitt)__ add a simple example to README
 * [a6e58ff](../../commit/a6e58ff) - __(Joshua Hoblitt)__ fix nssdb::create manage_certdir => false
 * [639d62e](../../commit/639d62e) - __(Joshua Hoblitt)__ set umask on generated pkcs12 file so the mode ends up as '0600'
 * [c208f6e](../../commit/c208f6e) - __(Joshua Hoblitt)__ change pkcs12 file generation to be based on existence of the output file
 * [5011b56](../../commit/5011b56) - __(Joshua Hoblitt)__ be explicit about ordering between nssdb::create & nssdb::add* types
 * [c585c7e](../../commit/c585c7e) - __(Joshua Hoblitt)__ change pkcs12 loading to check for existence of the pair in the db
 * [388a575](../../commit/388a575) - __(Joshua Hoblitt)__ add boilerplate .gitignore
 * [6c99034](../../commit/6c99034) - __(Joshua Hoblitt)__ add nssdb::add_cert define for importing certs into a db

In addition, this changeset is removing this functionality and the
cacert, canickname, and catrust params from the nssdb::create define.
It would be easy to add support back to that define as a wrapper around
the new nssdb::add_cert type or to add a new 'convenience' type to
accomplish the same thing.

 * [6fc4ead](../../commit/6fc4ead) - __(Joshua Hoblitt)__ add nssdb base class to ensure package deps

This will prevent duplicate package type declarations when using one of
the defined types multiple times in the same manifest.

 * [041e0e1](../../commit/041e0e1) - __(Joshua Hoblitt)__ replace concept of <basedir>/<dbname> with just <certdir> for flexibility

- replaces dbname, basedir params with certdir in nssdb::create &
  nssdb::add_cert_and_key
- add certdir_mode, manage_certdir params to nssdb::create
- also convert to 2 space indent + linter fixes

 * [2145c2b](../../commit/2145c2b) - __(Joshua Hoblitt)__ add stdlib to .fixtures.yml
 * [ca21742](../../commit/ca21742) - __(Joshua Hoblitt)__ add mode parameter to nssdb::create
 * [398e639](../../commit/398e639) - __(Rob Crittenden)__ Merge pull request [#1](../../issues/1) from rhaen/rspec_infrastructure

Added rspec test infrastructure, travis-ci, fixed typo
 * [83d3fa6](../../commit/83d3fa6) - __(Ulrich Habel)__ Allow ruby 2.0.0 and puppet version 2.7 to fail
 * [8989de1](../../commit/8989de1) - __(Ulrich Habel)__ Added rspec test infrastructure, travis-ci, fixed typo
 * [b3799a9](../../commit/b3799a9) - __(Rob Crittenden)__ Fix typo in derived Modulefile
 * [1a5bca3](../../commit/1a5bca3) - __(Rob Crittenden)__ Add missing Modulefile

#### release-1-0-0
 * [2878747](../../commit/2878747) - __(Rob Crittenden)__ Initial Release
