module M3Uzi2
  class Attributes < Hash
    def to_s
      self.map { | k, v | v.to_s }.join(',')
    end

    def self.parse(str)
      err_msg = 'Invalid Attribute/Value Pair: '
      if str.index(',').nil?
        fail err_msg << str unless str.index('=')
        yield str.split('=') if block_given?
      else
        str.split(',').each do | attr |
          fail err_msg << attr unless attr.index('=')
          yield attr.split('=') if block_given?
        end
      end
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
