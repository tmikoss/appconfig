module AppConfig
  class ModelSource < Source
    def initialize(options = {})
      @model_class = options[:class]
    end
    
    def reload_data!
      @hash = {}
      @model_class.all.each do |instance|
        @hash[instance.key] = instance.value
      end
    end
  end
end
