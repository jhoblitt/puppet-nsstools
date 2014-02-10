require 'spec_helper'

describe 'nssdb::add_cert', :type => :define do
  context 'default params' do
    let(:title) { 'GlobalSign Root CA' }
    let(:params) do
      {
        :certdir => '/dne',
        :cert    => '/tmp/server.crt',
      }
    end

    context 'add_cert' do
      it do
        should contain_exec('add_cert_GlobalSign Root CA').with(
          :path      => ['/usr/bin'],
          :command   => "certutil -d /dne -A -n 'GlobalSign Root CA' -t 'CT,,' -a -i /tmp/server.crt",
          :unless    => "certutil -d /dne -L -n 'GlobalSign Root CA'",
          :logoutput => true,
          :require   => [
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
        :certdir   => '/dne',
        :cert      => '/tmp/server.crt',
        :nickname  => 'GlobalSign Root CA',
        :trustargs => 'u,u,u',
      }
    end

    context 'add_cert' do
      it do
        should contain_exec('add_cert_foo').with(
          :path      => ['/usr/bin'],
          :command   => "certutil -d /dne -A -n 'GlobalSign Root CA' -t 'u,u,u' -a -i /tmp/server.crt",
          :unless    => "certutil -d /dne -L -n 'GlobalSign Root CA'",
          :logoutput => true,
          :require   => [
            'Nssdb::Create[/dne]',
            'Class[Nssdb]'
          ]
        )
      end
    end
  end # all params
end
