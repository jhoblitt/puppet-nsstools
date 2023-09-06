source 'https://rubygems.org'

gem "rake"
gem "puppet", ENV['PUPPET_VERSION'] || '~> 7.25'

group :lint do
  gem "puppet-lint", "~> 4.0"
  gem "puppet-syntax", "~> 3.3"
  gem "metadata-json-lint", "~> 3.0"
end

group :test do
  gem "rspec-puppet", "~> 3.0"
  gem "puppetlabs_spec_helper", "~> 6.0.1"
  gem "semantic_puppet", "~> 1.1.0"
end

group :beaker do
  gem 'serverspec',               :require => false
  gem 'beaker',                   :require => false
  gem 'beaker-rspec',             :require => false
  gem 'pry',                      :require => false
end

# vim:ft=ruby
