module M3Uzi2
  class Attributes < Hash
    def to_s
      self.map { | k, v | v.to_s }.join(',')
    end
  end

  class Attribute
    attr_reader :name,
                :value,
                :parent_tag

    def initialize(parent_tag, name, value = nil)
      @name = name
      @value = value
      @parent_tag = parent_tag
    end

    def parent_attribute(attr_name)
      parent_tag.attributes[attr_name]
    end

    def valid?
      @parent_tag.specification.check_attribute(self)
    end

    def to_s
      "#{name}=#{value}"
    end
  end
end
