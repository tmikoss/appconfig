require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Appconfig source setup" do
  describe "Adding YAML source" do
    it "when passed a string ending in .yml, should treat it as file path and add it as a YAML source" do
      AppConfig::Source.add(@sample_yaml_file_path)
      AppConfig::Source.list.size.should == 1
      AppConfig::Source.list.first.should be_is_a AppConfig::YamlSource
    end
    
    it "when passed a non-existent file path, should raise exception" do
      lambda{
        AppConfig::Source.add(File.expand_path(File.dirname(__FILE__) + '/this_file_does_not_exist.yml'))
      }.should raise_error
      AppConfig::Source.list.should be_empty
    end
  end
  
  describe "Adding ActiveRecord model source" do
    it "when passed a class that responds to slef.all, should treat it as a ActiveRecord model" do
      AppConfig::Source.add(SampleConfig)
      AppConfig::Source.list.size.should == 1
      AppConfig::Source.list.first.should be_is_a AppConfig::ModelSource
    end
    
    it "when passed a class that does not respond to slef.all, should not treat it as a ActiveRecord model" do
      lambda{
        AppConfig::Source.add(Object)
      }.should raise_error
      AppConfig::Source.list.should be_empty
    end
  end
  
  describe "Adding simple hash model source" do
    it "when passed a hash object, should treat it as simple hash source" do
      AppConfig::Source.add({:foo => 'bar'})
      AppConfig::Source.list.size.should == 1
      AppConfig::Source.list.first.should be_is_a AppConfig::Source
    end
  end
  
  describe "Adding unknown source" do
    it "should raise error when adding a source that does not match any known sources" do
      lambda{
        AppConfig::Source.add(:foobar)
      }.should raise_error
      AppConfig::Source.list.should be_empty
    end
  end
  
  describe "Source priority" do
    it "If adding multiple sources, keys from them all should be available" do
      AppConfig::Source.add({:one => 1})
      AppConfig::Source.add({:two => 2})
      
      AppConfig.one.should == 1
      AppConfig.two.should == 2
    end
    
    it "If adding multiple sources of different types, keys from them all should be available" do
      AppConfig::Source.add(@sample_yaml_file_path)
      AppConfig::Source.add({:one => 1})
      
      AppConfig.app_name.should == 'AppConfig'
      AppConfig.one.should == 1
    end
    
    it "If keys from multiple sources overlap, the one added last should be returned" do
      AppConfig::Source.add({:one => 1})
      AppConfig::Source.add({:one => 2})
      
      AppConfig.one.should == 2
    end
  end
  
  describe "Reloading sources" do
    it "should not automatically reflect changes in source" do
      SampleConfig.create(:key => 'app_name', :value => 'AppConfig')
      AppConfig::Source.add(SampleConfig)
      
      AppConfig.app_name.should == 'AppConfig'
      
      SampleConfig.create(:key => 'something_else', :value => 'something')
      
      lambda{
        AppConfig.something_else
      }.should raise_error
    end
    
    it "should reflect changes in model after reload has been called" do
      SampleConfig.create(:key => 'app_name', :value => 'AppConfig')
      AppConfig::Source.add(SampleConfig)
      
      AppConfig.app_name.should == 'AppConfig'
      
      SampleConfig.create(:key => 'something_else', :value => 'something')
      
      AppConfig::Source.reload_sources!
      
      AppConfig.something_else.should == 'something'
    end
  end
end
