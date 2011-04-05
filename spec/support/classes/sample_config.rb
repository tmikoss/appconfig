class SampleConfig
  @@storage = []
  
  attr_accessor :key
  attr_accessor :value
  
  def initialize(options = {})
    @key   = options[:key]
    @value = options[:value]
  end
  
  def create(options = {})
    initialize(options)
    @@storage << self
  end
  
  def self.all
    @@storage
  end
  
  def self.reset_storage!
    @@storage = []
  end
end
