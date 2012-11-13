require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "AppCfg retrieval from YAML" do
  describe "not environment namespaced" do
    before(:each) do
      AppCfg::Source.add(@sample_yaml_file_path)
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

  describe "environment namespaced" do
    before(:each) do
      AppCfg::Source.add(@sample_env_yaml_file_path, :env => 'test')
    end

    it "should support hash syntax for access" do
      AppCfg['app_name'].should == 'AppCfg'
    end

    it "should support object syntax for access" do
      AppCfg.app_name.should == 'AppCfg'
    end

    it "should allow multi-level access with hash syntax" do
      AppCfg['admin_credentials']['password'].should == 'testpass'
    end

    it "should allow multi-level access with object syntax" do
      AppCfg.admin_credentials.password.should == 'testpass'
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
  describe "environment namespaced (but namespace not found)" do
    before(:each) do
      AppCfg::Source.add(@sample_env_yaml_file_path, :env => 'bogus')
    end

    it "should load but be empty" do
      AppCfg['app_name'].should == nil
    end
  end

  describe "overlapping config files" do
    before(:each) do
      AppCfg::Source.add(@sample_env_yaml_file_path)
      AppCfg::Source.add(@sample_overlapping_file_path)
    end

    it "should merge hashes" do
      AppCfg.admin_credentials.username.should == 'admin'
      AppCfg.admin_credentials.enabled.should be_false
    end

    it "should overwrite values" do
      AppCfg.worker_count.should eq 4
      AppCfg.admin_credentials.password.should == 'newpass'
    end
  end
end
describe "AppCfg retrieval from empty YAML" do
  describe "not environment namespaced" do
    before(:each) do
      AppCfg::Source.add(@sample_yaml_empty_file_path)
    end

    it "should load but be empty" do
      AppCfg['app_name'].should == nil
    end
  end

  describe "environment namespaced" do
    before(:each) do
      AppCfg::Source.add(@sample_yaml_empty_file_path, :env => 'test')
    end

    it "should load but be empty" do
      AppCfg['app_name'].should == nil
    end
  end
end
