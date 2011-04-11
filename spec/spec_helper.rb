$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'appconfig'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.before(:each) do
    AppConfig::Source.class_variable_set '@@sources', []
    @sample_env_yaml_file_path = File.expand_path(File.dirname(__FILE__) + '/support/sample_env_config.yml')
    @sample_yaml_file_path     = File.expand_path(File.dirname(__FILE__) + '/support/sample_config.yml')
  end
end