require 'spec_helper'

describe 'nsstools::create', :type => :define do
  let(:facts) {{ :osfamily => 'RedHat' }}

  context 'default params' do
    let(:title) { '/obsolete' }
    let(:params) do
      {
        :owner    => 'nobody',
        :group    => 'nobody',
        :password => 'secret',
      }
    end

    context 'nsstools directory' do
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
        should contain_file('/obsolete/nss-password.txt').with(
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
            :require => [
              'File[/obsolete/nss-password.txt]',
              'Exec[create_nss_db_/obsolete]',
            ]
          )
        end
      end
    end

    context 'create nss db' do
      it do
        should contain_exec('create_nss_db_/obsolete').with(
          :command => %r{-d /obsolete -f /obsolete},
          :creates => [
            '/obsolete/cert8.db',
            '/obsolete/key3.db',
            '/obsolete/secmod.db'
          ],
          :require => [
            'File[/obsolete/nss-password.txt]',
            'Class[Nsstools]'
          ]
        )
      end
    end
  end # default params

  context 'all params' do
    # when certdir is set, title should not have to be an absolute path
    let(:title) { 'foo' }
    let(:params) do
      {
        :certdir        => '/obsolete',
        :owner          => 'nobody',
        :group          => 'nobody',
        :mode           => '0660',
        :password       => 'secret',
        :manage_certdir => false,
        :certdir_mode   => '0770',
      }
    end

    context 'nsstools directory' do
      it { should_not contain_file('/obsolete') }
    end

    context 'password file' do
      it do
        should contain_file('/obsolete/nss-password.txt').with(
          :owner   => 'nobody',
          :group   => 'nobody',
          :mode    => '0660',
          :content => 'secret',
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
            :require => [ 'File[/obsolete/nss-password.txt]', 'Exec[create_nss_db_foo]']
          )
        end
      end
    end

    context 'create nss db' do
      it do
        should contain_exec('create_nss_db_foo').with(
          :command => %r{-d /obsolete -f /obsolete},
          :creates => [
            '/obsolete/cert8.db',
            '/obsolete/key3.db',
            '/obsolete/secmod.db'
          ],
          :require => [
            'File[/obsolete/nss-password.txt]',
            'Class[Nsstools]'
          ]
        )
      end
    end
  end # all params
end
