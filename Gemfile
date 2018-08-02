source 'https://rubygems.org'
puppetversion = ENV.key?('PUPPET_VERSION') ? "= #{ENV['PUPPET_VERSION']}" : ['>= 2.7']

gem 'puppet', puppetversion

group :development, :test do
  gem 'puppet-blacksmith'
  gem 'puppet-lint'
  gem 'puppetlabs_spec_helper'
  gem 'rake'
  gem 'rspec'
  gem 'rspec-puppet'
  gem 'rspec-puppet-facts'
  gem 'guard'
  gem 'guard-rake'
  gem 'guard-rspec'
  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false
  gem 'growl',      :require => false
  gem 'libnotify',  :require => false
end
