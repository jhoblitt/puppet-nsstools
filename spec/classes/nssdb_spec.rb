require 'spec_helper'

describe 'nssdb', :type => :class do
  it { should contain_package('nss-tools') }
  it { should contain_package('openssl') }
end
