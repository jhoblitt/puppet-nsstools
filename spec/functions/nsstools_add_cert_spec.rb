require 'spec_helper'

describe 'nsstools_add_cert', :type => :puppet_function do
  it 'should fail with < 2 param' do
    expect { subject.call([1]) }.to raise_error(/Wrong number of arguments/)
  end

  it 'should fail with > 2 param' do
    expect { subject.call([1, 2, 3]) }.to raise_error(/Wrong number of arguments/)
  end

  it 'should require first arg to be a string' do
    expect { subject.call([1, 2]) }.to raise_error(/First argument must be a string/)
  end

  it 'should require second arg to be a hash' do
    expect { subject.call(['1', 2]) }.to raise_error(/Second argument must be a hash/)
  end

  it 'should work with reasonable input' do
    should run.with_params(
      '/etc/dirsrv/slapd-ldap1',
      {
        'AlphaSSL CA'        => '/tmp/alphassl_intermediate.pem',
        'GlobalSign Root CA' => '/tmp/globalsign_root.pem',
      }
    )

    alpha = catalogue.resource('Nsstools::Add_cert', '/etc/dirsrv/slapd-ldap1-AlphaSSL CA')
    expect(alpha[:nickname]).to eq 'AlphaSSL CA'
    expect(alpha[:certdir]).to eq '/etc/dirsrv/slapd-ldap1'
    expect(alpha[:cert]).to eq '/tmp/alphassl_intermediate.pem'

    global = catalogue.resource('Nsstools::Add_cert', '/etc/dirsrv/slapd-ldap1-GlobalSign Root CA')
    expect(global[:nickname]).to eq 'GlobalSign Root CA'
    expect(global[:certdir]).to eq '/etc/dirsrv/slapd-ldap1'
    expect(global[:cert]).to eq '/tmp/globalsign_root.pem'
  end
end
