require 'spec_helper'

describe 'nssdb::add_cert_and_key', :type => :define do
  let(:facts) {{ :osfamily => 'RedHat' }}

  context 'default params' do
    let(:title) { 'Server-Cert' }
    let(:params) do
      {
        :certdir => '/dne',
        :cert    => '/tmp/server.cert',
        :key     => '/tmp/server.key',
      }
    end

    context 'generate_pkcs12' do
      it do
        should contain_exec('generate_pkcs12_Server-Cert').with(
          :command   => "/usr/bin/openssl pkcs12 -export -in /tmp/server.cert -inkey /tmp/server.key -password 'file:/dne/nss-password.txt' -out '/dne/server-cert.p12' -name 'Server-Cert'",
          :require   => [
            'Nssdb::Create[/dne]',
            'Class[Nssdb]'
          ],
          :creates   => '/dne/server-cert.p12',
          :subscribe => 'File[/dne/nss-password.txt]'
        )
      end
    end

    context 'add_pkcs12' do
      it do
        should contain_exec('add_pkcs12_Server-Cert').with(
          :path      => ['/usr/bin'],
          :command   => "pk12util -d /dne -i /dne/server-cert.p12 -w /dne/nss-password.txt -k /dne/nss-password.txt",
          :unless    => "certutil -d /dne -L -n 'Server-Cert'",
          :logoutput => true,
          :require   => [
            'Exec[generate_pkcs12_Server-Cert]',
            'Nssdb::Create[/dne]',
            'Class[Nssdb]'
          ]
        )
      end
    end
  end # default params

  context 'all params' do
    let(:title) { 'foo' }
    let(:params) do
      {
        :nickname => 'Server-Cert',
        :certdir  => '/dne',
        :cert     => '/tmp/server.cert',
        :key      => '/tmp/server.key',
      }
    end

    context 'generate_pkcs12' do
      it do
        should contain_exec('generate_pkcs12_foo').with(
          :command   => "/usr/bin/openssl pkcs12 -export -in /tmp/server.cert -inkey /tmp/server.key -password 'file:/dne/nss-password.txt' -out '/dne/server-cert.p12' -name 'Server-Cert'",
          :require   => [
            'Nssdb::Create[/dne]',
            'Class[Nssdb]'
          ],
          :creates   => '/dne/server-cert.p12',
          :subscribe => 'File[/dne/nss-password.txt]'
        )
      end
    end

    context 'add_pkcs12' do
      it do
        should contain_exec('add_pkcs12_foo').with(
          :path      => ['/usr/bin'],
          :command   => "pk12util -d /dne -i /dne/server-cert.p12 -w /dne/nss-password.txt -k /dne/nss-password.txt",
          :unless    => "certutil -d /dne -L -n 'Server-Cert'",
          :logoutput => true,
          :require   => [
            'Exec[generate_pkcs12_foo]',
            'Nssdb::Create[/dne]',
            'Class[Nssdb]'
          ]
        )
      end
    end
  end # all params
end
