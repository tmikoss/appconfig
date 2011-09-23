module AppCfg
  class YamlSource < Source
    def initialize(options = {})
      @filename  = options[:file]
      @namespace = options[:env]
    end
    
    def reload_data!
      yaml_structure = YAML.load(File.open @filename) || {} # empty hash instead of false when file is empty
      @hash          = @namespace ? yaml_structure[@namespace]||{} : yaml_structure
    end
  end
end
