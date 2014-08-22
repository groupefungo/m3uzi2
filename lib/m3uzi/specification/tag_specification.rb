require_relative 'attribute_specification'
require_relative 'constraints'

module M3Uzi2
  class TagSpecification
    attr_reader :attributes

    def initialize(tag_name)
      @name = tag_name
      @attributes = {}
      @constaints = M3Uzi2::Constraints.new
    end

    def add_attribute(name, &block)
      @attributes[name] = M3Uzi2::AttributeSpecification.new('METHOD', &block)
    end

    def [](key)
      return @attributes[key]
    end

    def valid_attribute?(tag, attribute)
      @attributes.keys.include?(attribute.name)
    end

    def add_constraint(&block)
      @constaints.add(&block)
    end

    def valid?(tag)
      @constaints.valid?(tag) && @attributes.all? do | k, v |
        tag.attributes[k].nil? ? true : v.valid?(tag.attributes[k])
      end
    end
  end
end
