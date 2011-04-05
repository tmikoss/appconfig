#Shamelessly lifted from http://blog.jayfields.com/2008/01/ruby-hashtomod.html

class Object
  def to_obj
    self
  end
end

class Hash
  def to_mod
    hash = self
    Module.new do
      hash.each_pair do |key, value|
        define_method key do
          value.to_obj
        end
      end
    end
  end
  
  def to_obj
    self.dup.extend self.to_mod
  end
end