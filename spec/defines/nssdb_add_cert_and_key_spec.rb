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
      should contain_exec('generate_pkcs12').with(
        :command   => "/usr/bin/openssl pkcs12 -export -in /tmp/server.cert -inkey /tmp/server.key -password 'file:/dne/password.conf' -out '/dne/server-cert.p12' -name 'Server-Cert'",
        :require   => [
          'File[/dne/password.conf]',
          'File[/dne/cert8.db]',
          'Package[openssl]'
        ],
        :subscribe => 'File[/dne/password.conf]'
      )
    end
  end

  context 'load_pkcs12' do
    it do
      contain_exec('load_pkcs12').with(
        :command => "/usr/bin/pk12util -i '/dne/${pkcs12_name}' -d '/dne' -w '/dne/password.conf' -k '/dne/password.conf'"
      )
    end
  end

end
