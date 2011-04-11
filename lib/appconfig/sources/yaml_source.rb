module AppConfig
  class YamlSource < Source
    def initialize(options = {})
      yaml_structure = YAML.load(File.open options[:file])
      @hash          = options[:env] ? yaml_structure[options[:env]] : yaml_structure
    end
  end
end
