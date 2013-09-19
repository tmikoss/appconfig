module AppCfg
  class ModelSource < Source
    def initialize(options = {})
      @model_class = options[:class]
    end

    def reload_data!
      @hash = {}
      @model_class.all.each do |instance|
        #@hash[instance.key] = instance.value
        hsh = @hash
        idx = {}
        arr = instance.key.split('.')
        arr.each_with_index do |x,i|
          hsh[x] ||= {}
          if arr.size-1 == i
            hsh[x] = instance.value
          else
            hsh = hsh[x]
          end
        end
      end
    end
  end
end
