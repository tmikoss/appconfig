module AppConfig
  class Source
    @@sources = []
    
    def initialize(options={})
      @hash = {}
    end
    
    def to_hash
      @hash
    end
    
    def self.add(source_object, options={})
      if source_object.is_a?(String) && source_object[-4..-1] == '.yml'
        #YAML
        raise "File #{source_object} could not be located" unless File.exist? source_object
        add_source(YamlSource.new(options.merge(:file => source_object)))
      else  
        raise 'Could not match source object to any known types'
      end
    end
    
    def self.list
      @@sources
    end
    
    private
    
    def self.add_source(source)
      @@sources << source
      reload_sources!
    end
    
    def self.reload_sources!
      cache = {}
      
      @@sources.each do |source|
        cache = cache.merge(source.to_hash)
      end
      
      AppConfig.class_variable_set '@@cache', hash_to_object(cache)
    end
    
    #Credit to http://blog.jayfields.com/2008/01/ruby-hashtomod.html
    def self.hash_to_object(hash)
      mod = Module.new do
        hash.each_pair do |key, value|
          define_method key do
            value.is_a?(Hash) ? AppConfig::Source.hash_to_object(value) : value
          end
        end
      end
      
      new_hash = hash.dup
      
      new_hash.extend mod
      
      new_hash
    end
  end
end