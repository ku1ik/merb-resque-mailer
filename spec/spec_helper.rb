$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'spec'
require 'spec/autorun'

require 'merb-core'
require 'merb-mailer'

Merb::Config.use do |c|
  c[:session_store] = :memory
end

# Merb.start :environment => 'test'
Merb.start_environment(:testing => true, :adapter => 'runner', :environment => 'test')
Merb::Mailer.delivery_method = :test_send

require 'merb-resque-mailer'

Spec::Runner.configure do |config|
  config.include Merb::Test::RequestHelper
  config.include Merb::Test::ControllerHelper
end
