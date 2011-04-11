require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Appconfig retrieval from simple hash" do  
  before(:each) do
    @config_hash = {'app_name' => 'AppConfig', 'admin_credentials' => {'username' => 'admin', 'password' => 'testpass'}}
    AppConfig::Source.add(@config_hash)
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