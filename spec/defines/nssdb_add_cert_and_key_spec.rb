require 'spec_helper'

describe 'nssdb::add_cert_and_key', :type => :define do
  let(:title) { '/dne' }
  let(:params) do
    {
      :nickname => 'Server-Cert',
      :cert     => '/tmp/server.cert',
      :key      => '/tmp/server.key',
    }
  end

  context 'generate_pkcs12' do
    it do
      should contain_exec('generate_pkcs12_/dne').with(
        :command   => "/usr/bin/openssl pkcs12 -export -in /tmp/server.cert -inkey /tmp/server.key -password 'file:/dne/password.conf' -out '/dne/server-cert.p12' -name 'Server-Cert'",
        :require   => [
          'File[/dne/password.conf]',
          'File[/dne/cert8.db]',
          'Class[Nssdb]'
        ],
        :subscribe => 'File[/dne/password.conf]'
      )
    end
  end

  context 'add_pkcs12' do
    it do
      should contain_exec('add_pkcs12_/dne').with(
        :path      => ['/usr/bin'],
        :command   => "pk12util -d /dne -i /dne/server-cert.p12 -w /dne/password.conf -k /dne/password.conf",
        :unless    => "certutil -d /dne -L -n 'Server-Cert'",
        :logoutput => true,
        :require   => [
          'Exec[generate_pkcs12_/dne]',
          'Class[Nssdb]'
        ]
      )
    end
  end

end
