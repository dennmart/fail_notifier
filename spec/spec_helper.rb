require 'rubygems'
require 'bundler'
Bundler.require(:default, :test)

require 'fail_notifier'
set :environment, :test

Spec::Runner.configure do |config|
  config.include Rack::Test::Methods
end

