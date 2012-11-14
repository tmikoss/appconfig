module AppCfg
  def self.set_cache data
    @@cache = data
  end

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
      elsif source_object.is_a?(String) && source_object[-11..-1] == '.properties'
        #.properties
        raise "File #{source_object} could not be located" unless File.exist? source_object
        add_source(PropertiesSource.new(options.merge(:file => source_object)))
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

    def self.clear
      @@sources = []
      reload_sources!
    end

    def self.list
      @@sources
    end

    def self.reload_sources!
      cache = {}

      @@sources.each do |source|
        source.reload_data!
        cache = recursive_merge(cache, source.to_hash)
      end

      AppCfg.set_cache add_key_methods cache
    end

    private

    def self.add_source(source)
      @@sources << source
      reload_sources!
    end

    def self.recursive_merge(base, other)
      other.each do |key, value|
        if base[key].is_a?(Hash) && value.is_a?(Hash)
          base[key] = recursive_merge(base[key], value)
        else
          base[key] = value
        end
      end

      base
    end

    def self.add_key_methods(base)
      mod = Module.new do
        base.each do |key, value|
          define_method key do
            value
          end
        end
      end

      base.extend mod

      base.each do |key, value|
        next unless value.is_a? Hash
        base[key] = add_key_methods(value)
      end

      base
    end
  end
end
