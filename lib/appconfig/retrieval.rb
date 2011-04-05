module AppConfig
  def self.[](key)
    if @@cache.respond_to?(key)
      @@cache.send(key)
    else
      nil
    end
  end
  
  def self.method_missing(method_sym, *arguments, &block)
    if @@cache.respond_to?(method_sym)
      @@cache.send(method_sym)
    else
      super
    end
  end
  
  def self.respond_to?(method_sym, include_private = false)
    if @@cache.respond_to?(method_sym)
      true
    else
      super
    end
  end
end