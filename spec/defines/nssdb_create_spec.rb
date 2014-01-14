require 'spec_helper'

describe 'nssdb::create', :type => :define do
  context 'default params' do
    let(:title) { '/obsolete' }
    let(:params) do
      {
        :owner_id       => 'nobody',
        :group_id       => 'nobody',
        :password       => 'secret',
      }
    end

    context 'nssdb directory' do
      it do
        should contain_file('/obsolete').with(
          :owner => 'nobody',
          :group => 'nobody',
          :mode  => '0700'
        )
      end
    end

    context 'password file' do
      it do
        should contain_file('/obsolete/password.conf').with(
          :owner   => 'nobody',
          :group   => 'nobody',
          :mode    => '0600',
          :content => 'secret',
          :require => 'File[/obsolete]'
        )
      end
    end

    context 'database files' do
      databases = ['cert8.db', 'key3.db', 'secmod.db']
      databases.each do |db|
        it do
          should contain_file('/obsolete/' + db).with(
            :owner   => 'nobody',
            :group   => 'nobody',
            :mode    => '0600',
            :require => [ 'File[/obsolete/password.conf]', 'Exec[create_nss_db]']
          )
        end
      end
    end

    context 'create nss db' do
      it do
        should contain_exec('create_nss_db').with(
          :command => %r{-d /obsolete -f /obsolete},
          :creates => [
            '/obsolete/cert8.db',
            '/obsolete/key3.db',
            '/obsolete/secmod.db'
          ],
          :require => [
            'File[/obsolete]',
            'File[/obsolete/password.conf]',
            'Package[nss-tools]'
          ]
        )
      end
    end

    context 'add ca cert' do
      it do
        should contain_exec('add_ca_cert').with(
          :command => '/usr/bin/certutil -A -n CA -d /obsolete -t CT,CT, -a -i /etc/pki/certs/CA/ca.crt',
          :onlyif  => '/usr/bin/test -e /etc/pki/certs/CA/ca.crt',
        )
      end
    end
  end # default params

  context 'all params' do
    let(:title) { '/obsolete' }
    let(:params) do
      {
        :owner_id       => 'nobody',
        :group_id       => 'nobody',
        :mode           => '0660',
        :password       => 'secret',
        :manage_certdir => false,
        :certdir_mode   => '0770',
        :cacert         => '/ca.crt',
        :canickname     => 'ca',
        :catrust        => 'CTu'
      }
    end

    context 'nssdb directory' do
      it { should_not contain_file('/obsolete') }
    end

    context 'password file' do
      it do
        should contain_file('/obsolete/password.conf').with(
          :owner   => 'nobody',
          :group   => 'nobody',
          :mode    => '0660',
          :content => 'secret',
          :require => 'File[/obsolete]'
        )
      end
    end

    context 'database files' do
      databases = ['cert8.db', 'key3.db', 'secmod.db']
      databases.each do |db|
        it do
          should contain_file('/obsolete/' + db).with(
            :owner   => 'nobody',
            :group   => 'nobody',
            :mode    => '0660',
            :require => [ 'File[/obsolete/password.conf]', 'Exec[create_nss_db]']
          )
        end
      end
    end

    context 'create nss db' do
      it do
        should contain_exec('create_nss_db').with(
          :command => %r{-d /obsolete -f /obsolete},
          :creates => [
            '/obsolete/cert8.db',
            '/obsolete/key3.db',
            '/obsolete/secmod.db'
          ],
          :require => [
            'File[/obsolete]',
            'File[/obsolete/password.conf]',
            'Package[nss-tools]'
          ]
        )
      end
    end

    context 'add ca cert' do
      it do
        should contain_exec('add_ca_cert').with(
          :command => %r{-n ca -d /obsolete -t CTu.*-i /ca.crt},
          :onlyif  => %r{-e /ca.crt}
        )
      end
    end
  end # all params
end
