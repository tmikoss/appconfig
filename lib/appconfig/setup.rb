module AppConfig
  class Setup
    @@setup = AppConfig::Setup.new
    
    attr_accessor :yaml_file
    attr_accessor :model_class
    attr_accessor :environment
    attr_accessor :model_can_overwrite_file
    
    def self.setup
      if defined?(Rails) && Rails.respond_to?(:env)
        @environment = Rails.env
      end
      yield @@setup
      reload_all!
    end

    def self.reload_all!
      cache = {}
      
      if @@setup.yaml_file
        yaml_structure = YAML.load(File.open @@setup.yaml_file)
        
        cache = @@setup.environment ? yaml_structure[@@setup.environment] : yaml_structure
      end

      if @@setup.model_class
        @@setup.model_class.all.each do |model|
          cache[model.key] = model.value if @@setup.model_can_overwrite_file || !cache.has_key?(model.key)
        end
      end
      
      AppConfig.class_variable_set '@@cache', cache.to_obj
    end
  end
end