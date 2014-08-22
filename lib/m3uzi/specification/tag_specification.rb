require_relative 'attribute_specification'
require_relative 'constraints'

module M3Uzi2
  # ==== Description
  # Container class for the *specification* of an M3U8 'tag' as EXT-X-KEY
  class TagSpecification
    attr_reader :name,
                :attributes

    def initialize(tag_name)
      @name = tag_name
      @attributes = {}
      @constaints = M3Uzi2::Constraints.new
    end

    # ==== Description
    # Return an Attribute via key/attribute name
    #
    # ==== Params
    # +attribute_name+ :: name of the attribute to return
    def [](attribute_name)
      return @attributes[attribute_name]
    end

    # given an array of strings, create an Attribute for each, using string
    # for the name
    def create_attributes(array)
      array.each { | a | create_attribute(a) }
    end

    def create_attribute(name)
      return @attributes[name] = AttributeSpecification.new('METHOD')
    end

    def add_constraint(err_msg, &block)
      @constaints.add(err_msg, &block)
    end

    def add(klass)
      case klass
      when AttributeSpecification
        @attributes[klass.name] = klass.name
      when Constraint
        @constraints << klass
      else
        fail "Cannot add a #{klass.class} to a #{self.class}"
      end
    end

    # ==== Description
    # Is the attribute a valid attibute of the tag? Note the attribute must
    # respond to the name message
    def valid_attribute?(attribute)
      @attributes.keys.include?(attribute.name)
    end

    # ==== Description
    # Givan an instance of a tag, test if the tag and all attributes are valid
    # against the M3U8 RFC.
    def valid?(tag)
      @constaints.valid?(tag) && @attributes.all? do | k, v |
        tag.attributes[k].nil? ? true : v.valid?(tag.attributes[k])
      end
    end
  end
end
