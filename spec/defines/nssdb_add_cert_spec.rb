require 'spec_helper'

describe 'nssdb::add_cert', :type => :define do
  let(:title) { '/dne' }
  let(:params) do
    {
      :nickname => 'GlobalSign Root CA',
      :cert     => '/tmp/server.crt',
    }
  end

  context 'add_cert' do
    it do
      should contain_exec('add_cert_/dne').with(
        :path      => ['/usr/bin'],
        :command   => "certutil -d /dne -A -n 'GlobalSign Root CA' -t 'CT,,' -a -i /tmp/server.crt",
        :unless    => "certutil -d /dne -L -n 'GlobalSign Root CA'",
        :logoutput => true,
        :require   => [
          'Class[Nssdb]'
        ],
      )
    end
  end
end
