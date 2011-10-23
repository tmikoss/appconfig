require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "AppCfg retrieval from Properties" do
  describe "not environment namespaced" do
    before(:each) do
      AppCfg::Source.add(@sample_properties_file_path)
    end

    it "should support hash syntax for access" do
      AppCfg['app_name'].should == 'AppCfg'
    end

    it "should support object syntax for access" do
      AppCfg.app_name.should == 'AppCfg'
    end

    # Currently N/A to .properties files
    #
    # it "should allow multi-level access with hash syntax" do
    #   AppCfg['admin_credentials']['username'].should == 'admin'
    # end
    #
    # it "should allow multi-level access with object syntax" do
    #   AppCfg.admin_credentials.username.should == 'admin'
    # end

    it "should return nil on non-existent key, hash syntax" do
      AppCfg['wrong_key'].should be_nil
    end

    it "should raise error on non-existent key, object syntax" do
      lambda {
        AppCfg.wrong_key
      }.should raise_error
    end

    it "Should not trim trailing spaces" do
      AppCfg['has'].should == "five trailing spaces     "
    end

    # Not yet supported
    # it "should support colon-delimited properties" do
    #   AppCfg['colon'].should == "another delimiter"
    # end
    #
    # it "should trim spaces around delimiter" do
    #   AppCfg["website"].should == "http://en.wikipedia.org/"
    # end
    #
    # it "should support multi-line values" do
    #   AppCfg["message"].should == "Welcome to         Wikipedia!"
    # end
    #
    # it "should support keys with spaces" do
    #   AppCfg["key with spaces"].should == 'This is the value that could be looked up with the key "key with spaces".'
    # end
    #
    # it "should support Unicode escapes" do
    #   AppCfg["tab"].should == "\t"
    # end
  end
end

describe "AppCfg retrieval from empty properties" do
  describe "not environment namespaced" do
    before(:each) do
      AppCfg::Source.add(@sample_properties_empty_file_path)
    end

    it "should load but be empty" do
      AppCfg['app_name'].should == nil
    end
  end
end
