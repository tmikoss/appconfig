require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "AppCfg retrieval from AR model" do  
  before(:each) do
    SampleConfig.create(:key => 'app_name', :value => 'AppCfg')
    SampleConfig.create(:key => 'admin_credentials', :value => {'username' => 'admin', 'password' => 'testpass'})
    AppCfg::Source.add(SampleConfig)
  end

  it "should support hash syntax for access" do
    AppCfg['app_name'].should == 'AppCfg'
  end
  
  it "should support object syntax for access" do
    AppCfg.app_name.should == 'AppCfg'
  end
  
  it "should allow multi-level access with hash syntax" do
    AppCfg['admin_credentials']['username'].should == 'admin'
  end
  
  it "should allow multi-level access with object syntax" do
    AppCfg.admin_credentials.username.should == 'admin'
  end
  
  it "should return nil on non-existent key, hash syntax" do
    AppCfg['wrong_key'].should be_nil
  end
  
  it "should raise error on non-existent key, object syntax" do
    lambda {
      AppCfg.wrong_key
    }.should raise_error
  end
end
