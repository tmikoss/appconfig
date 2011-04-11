require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Appconfig retrieval from YAML" do
  describe "not environment namespaced" do
    before(:each) do
      AppConfig::Source.add(@sample_yaml_file_path)
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
      AppConfig::Source.add(@sample_env_yaml_file_path, :env => 'test')
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
