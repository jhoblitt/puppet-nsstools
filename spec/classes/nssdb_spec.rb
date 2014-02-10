require 'spec_helper'

describe 'nssdb', :type => :class do
  describe 'on osfamily RedHat' do
    let(:facts) {{ :osfamily => 'RedHat' }}

    context 'default params' do
      # rspec-puppet relationship matchers seem to be buggy in 1.0.1
      # it { should contain_class('openssl').that_comes_before('Class[nssdb]') }
      it { should contain_class('openssl') }
      it { should contain_package('nss-tools') }
    end # default params

    context 'require_openssl =>' do
      context 'true' do
        let(:params) {{ :require_openssl => true }}

        it { should contain_class('openssl') }
        it { should contain_package('nss-tools') }
      end

      context 'false' do
        let(:params) {{ :require_openssl => false }}

        it { should_not contain_class('openssl') }
        it { should contain_package('nss-tools') }
      end

      context 'foo' do
        let(:params) {{ :require_openssl => 'foo' }}

        it 'should fail' do
          expect { should contain_class('nssdb') }.
            to raise_error(/not a boolean./)
        end
      end
    end # default params
  end # on osfamily RedHat

  describe 'unsupported osfamily' do
    let :facts do
      {
        :osfamily        => 'Debian',
        :operatingsystem => 'Debian',
      }
    end

    it 'should fail' do
      expect { should compile }.to raise_error(/not supported on Debian/)
    end
  end # unsupported osfamily

end
