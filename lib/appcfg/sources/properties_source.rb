module AppCfg

  # TODO: consider treating . in properties names as a nesting operatator. E.g. maven.groupId=xyz creates AppCfg['maven'] = { 'groupId' => 'xyz' }
  # TODO: environment support? Perhaps file-name convention or also with .-delimited properties names? E.g. maven.groupId.test

  class PropertiesSource < Source
    def initialize(options = {})
      @filename = options[:file]
      @namespace = options[:env]
    end

    def reload_data!
      properties = JavaProperties.new(@filename)
      @hash = properties.properties
    end
  end


  # JavaProperties class from https://github.com/axic/rsnippets/blob/master/javaproperties.rb (originally from
  # https://devender.wordpress.com/2006/05/01/reading-and-writing-java-property-files-with-ruby/)
  #
  # Consider splitting into own project and including as a gem. Some features missing: escape handling
  # error handling, perhaps whitespace edge cases as well.
  #
  # Consider checking for presence of JRuby and invoking java.util.Properties if available.
  class JavaProperties
    attr_accessor :filename, :properties

    def initialize(filename)
      @filename = filename
      @properties = {}

      IO.foreach(@filename) do |line|
        @properties[$1.strip] = $2 if line = ~ /([^=]*)=(.*)\/\/(.*)/ || line =~ /([^=]*)=(.*)/
      end
    end

    def to_s
      output = "File name #{@file}\n"
      @properties.each { |key, value| output += " #{key} = #{value}\n" }
      output
    end

    def add(key, value = nil)
      return unless key.length > 0
      @properties[key] = value
    end

    def remove(key)
      return unless key.length > 0
      @properties.delete(key)
    end

    def save
      file = File.new(@filename, "w+")
      @properties.each { |key, value| file.puts "#{key}=#{value}\n" }
      file.close
    end
  end

end
