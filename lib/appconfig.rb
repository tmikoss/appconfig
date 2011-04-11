require 'yaml'
require 'appconfig/retrieval'
require 'appconfig/source'
require 'appconfig/sources/yaml_source'
require 'appconfig/sources/model_source'

module AppConfig
  @@cache = {}
end
