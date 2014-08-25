
module M3Uzi2
  class Tags < Hash; end

  class Tag
    # FULL NAME INCLUDING THE EXT-X
    attr_reader :name,
                :value,
                :attributes

    attr_accessor :specification

    def initialize(name, value = nil)
      @name = name
      @value = value

      @attributes = M3Uzi2::Attributes.new
    end

    def add_attribute(name, value)
      fail "Cannot add attributes to a #{self.class.name} that has a value!" if @value

      @attributes[name] = nil
      @attributes[name] = M3Uzi2::Attribute.new(self, name, value)
    end

    def valid?
      @specification.check_tag(self) && @attributes.all? do | k, v |
        v.valid?
      end
    end

    def to_s
      "##{@name}#{@value || @attributes.size > 0 ? ':' : ''}#{@attributes}#{@value}"
    end

    def version
      @specification[name].min_version
    end


    def value=(val)
      fail "Cannot set a value on a #{self.class.name} that has attributes!" if @attributes.size > 0
      @value = val
    end
  end
end
