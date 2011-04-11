module AppCfg
  class Source
    @@sources = []
    
    def initialize(options={})
      @hash = options
    end
    
    def to_hash
      @hash
    end
    
    def reload_data!
      #Do nothing
    end
    
    def self.add(source_object, options={})
      if source_object.is_a?(String) && source_object[-4..-1] == '.yml'
        #YAML
        raise "File #{source_object} could not be located" unless File.exist? source_object
        add_source(YamlSource.new(options.merge(:file => source_object)))
      elsif source_object.is_a?(Class) && source_object.respond_to?(:all)
        #AR Model
        add_source(ModelSource.new(options.merge(:class => source_object)))
      elsif source_object.is_a?(Hash)
        #Simple hash
        add_source(Source.new(source_object))
      else
        raise 'Could not match source object to any known types'
      end
    end
    
    def self.list
      @@sources
    end
    
    def self.reload_sources!
      cache = {}
      
      @@sources.each do |source|
        source.reload_data!
        cache = cache.merge(source.to_hash)
      end
      
      AppCfg.class_variable_set '@@cache', hash_to_object(cache)
    end
    
    private
    
    def self.add_source(source)
      @@sources << source
      reload_sources!
    end
    
    #Credit to http://blog.jayfields.com/2008/01/ruby-hashtomod.html
    def self.hash_to_object(hash)
      mod = Module.new do
        hash.each_pair do |key, value|
          define_method key do
            value.is_a?(Hash) ? AppCfg::Source.hash_to_object(value) : value
          end
        end
      end
      
      new_hash = hash.dup
      
      new_hash.extend mod
      
      new_hash
    end
  end
end