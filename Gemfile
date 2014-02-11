source 'https://rubygems.org'

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

gem 'rake',                           :require => false
gem 'puppetlabs_spec_helper',         :require => false
gem 'puppet-lint',                    :require => false
gem 'puppet-syntax',                  :require => false
# The patch needed to properly test the nsstools_add_cert() function
#   https://github.com/rodjek/rspec-puppet/pull/155
#   https://github.com/rodjek/rspec-puppet/commit/03e94422fb9bbdd950d5a0bec6ead5d76e06616b
gem 'rspec-puppet', '1.0.1', :git => 'https://github.com/rodjek/rspec-puppet.git', :ref => '03e94422fb9bbdd950d5a0bec6ead5d76e06616b', :require => false
