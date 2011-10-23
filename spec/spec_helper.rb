require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'appcfg'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.before(:each) do
    AppCfg::Source.clear
    @sample_env_yaml_file_path         = File.expand_path(File.dirname(__FILE__) + '/support/sample_env_config.yml')
    @sample_yaml_file_path             = File.expand_path(File.dirname(__FILE__) + '/support/sample_config.yml')
    @sample_yaml_empty_file_path       = File.expand_path(File.dirname(__FILE__) + '/support/sample_empty_config.yml')
    @sample_properties_file_path       = File.expand_path(File.dirname(__FILE__) + '/support/sample_config.properties')
    @sample_properties_empty_file_path = File.expand_path(File.dirname(__FILE__) + '/support/sample_empty_config.properties')
  end
  
  config.after(:each) do
    SampleConfig.reset_storage!
  end
end
