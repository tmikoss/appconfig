require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Appconfig" do
  before(:each) do
    @sample_env_yaml_file_path = File.expand_path(File.dirname(__FILE__) + '/support/sample_env_config.yml')
    @sample_yaml_file_path     = File.expand_path(File.dirname(__FILE__) + '/support/sample_config.yml')
    AppConfig::Setup.class_variable_set '@@setup', AppConfig::Setup.new
  end
  
  describe "Setup" do
    it "configuration should be blank by default" do
      config = AppConfig::Setup.class_variable_get '@@setup'
      
      config.yaml_file.should be_nil
      config.model_can_overwrite_file.should be_nil
      config.model_class.should be_nil
      config.environment.should be_nil
    end
    
    it "should be configurable by block" do
      lambda { AppConfig::Setup.setup do |c|
        c.yaml_file                = @sample_env_yaml_file_path
        c.model_can_overwrite_file = true
        c.model_class              = SampleConfig
        c.environment              = 'test'
      end }.should_not raise_error
    end
    
    it "should save the configuration values" do
      AppConfig::Setup.setup do |c|
        c.yaml_file                = @sample_env_yaml_file_path
        c.model_can_overwrite_file = true
        c.model_class              = SampleConfig
        c.environment              = 'test'
      end
      
      config = AppConfig::Setup.class_variable_get '@@setup'
      
      config.yaml_file.should == @sample_env_yaml_file_path
      config.model_can_overwrite_file.should be_true
      config.model_class.should == SampleConfig
      config.environment.should == 'test'
    end
    
    describe "if Rails (~ 3.0) is present" do
      before(:each) do
        module Rails
          def self.env
            'production'
          end
        end
      end

      pending "should automatically pick up environment if it is not specified" do
        AppConfig::Setup.setup do |c|
          c.yaml_file = @sample_env_yaml_file_path
        end
        
        config = AppConfig::Setup.class_variable_get '@@setup'
        
        config.environment.should == 'production'
      end
      
      it "should still allow to configure environment" do
        AppConfig::Setup.setup do |c|
          c.yaml_file = @sample_env_yaml_file_path
          c.environment = 'test'
        end
        
        config = AppConfig::Setup.class_variable_get '@@setup'
        
        config.environment.should == 'test'
      end
    end
  end
  
  describe "Retrieval from YAML" do
    describe "not environment namespaced" do
      before(:each) do
        AppConfig::Setup.setup do |c|
          c.yaml_file = @sample_yaml_file_path
        end
      end
      
      it "should support hash syntax for access" do
        AppConfig['app_name'].should == 'AppConfig'
      end
      
      it "should support object syntax for access" do
        AppConfig.app_name.should == 'AppConfig'
      end
      
      it "should allow multi-level access with hash syntax" do
        AppConfig['admin_credentials']['username'].should == 'admin'
      end
      
      it "should allow multi-level access with object syntax" do
        AppConfig.admin_credentials.username.should == 'admin'
      end
      
      it "should return nil on non-existent key, hash syntax" do
        AppConfig['wrong_key'].should be_nil
      end
      
      it "should raise error on non-existent key, object syntax" do
        lambda {
          AppConfig.wrong_key
        }.should raise_error
      end
    end
    
    describe "environment namespaced" do
      before(:each) do
        AppConfig::Setup.setup do |c|
          c.yaml_file   = @sample_env_yaml_file_path
          c.environment = 'test'
        end
      end
      
      it "should support hash syntax for access" do
        AppConfig['app_name'].should == 'AppConfig'
      end
      
      it "should support object syntax for access" do
        AppConfig.app_name.should == 'AppConfig'
      end
      
      it "should allow multi-level access with hash syntax" do
        AppConfig['admin_credentials']['password'].should == 'testpass'
      end
      
      it "should allow multi-level access with object syntax" do
        AppConfig.admin_credentials.password.should == 'testpass'
      end
      
      it "should return nil on non-existent key, hash syntax" do
        AppConfig['wrong_key'].should be_nil
      end
      
      it "should raise error on non-existent key, object syntax" do
        lambda {
          AppConfig.wrong_key
        }.should raise_error
      end
    end
  end
end
