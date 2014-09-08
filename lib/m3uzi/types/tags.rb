require_relative '../error_handler'
require_relative 'attributes'

module M3Uzi2
  class Tags < Hash; end

  # ==== Description
  # Represents an instance of a m3u8 tag which can be validated
  # against a specification.
  class Tag
    include ErrorHandler

    
    attr_reader :name,		# FULL NAME INCLUDING THE EXT-X
                :value,
                :attributes

    attr_accessor :specification

    # ==== Description
    # Note that if you are creating a tag manually and want to
    # validate it, you MUST either pass specification in or set it
    # before calling valid?.
    def initialize(name, value = nil, specification: nil)
      @name = name
      @value = value
      @specification = specification

      @attributes = Attributes.new
    end

    # Set the Tags value. Note that attempting to set a value on a tag
    # that has attributes will raise StandardError
    def value=(val)
      fail "Cannot set a value on a #{self.class.name} "\
           'that has attributes!' if @attributes.size > 0
      @value = val
    end

    # ==== Description
    # The passed +attributes+ parameter should be a string containing
    # one or more comma seperated attribute=value pairs.
    def add_attributes(attributes)
      return handle_stream_inf(attributes) if name == 'EXT-X-I-FRAME-STREAM-INF'

      Attributes.parse(attributes) do | n, v |
        add_attribute(n, v)
      end
    end

    # Convenience method to access attributes via [attibute_name] 
    # semantics.
    def [](key)
      @attributes[key]
    end

    # Convenience method to access attributes via [attibute_name]=val
    # semantics, and allow an existing attributes value to be changed.
    def []=(key, value)
      fail_if_value_exculudes_attribute
      @attributes[key] = value
    end

    # Create a new attribute from a name, value pair
    # Note that attempting to add an attribute on a tag
    # that has a value will raise StandardError
    def add_attribute(name, value)
      fail_if_value_exculudes_attribute
      @attributes[name] = Attribute.new(self, name, value)
    end

    # Returns true if and only if the Tag AND all attributes are valid
    def valid?
      @specification.check_tag(self) && @attributes.all? { | _k, v | v.valid? }
    end

    def to_s
      "##{@name}#{@value || @attributes.size > 0 ? ':' : ''}"\
      "#{@attributes}#{@value}"
    end

    def version
      @specification[@name].min_version
    end

    def playlist_compatability
      @specification[@name].playlist_compatability
    end

    def valid_occurance_range
      @specification[@name].valid_occurance_range
    end

    private

    def fail_if_value_exculudes_attribute
      fail "Cannot add attributes to a #{self.class.name} "\
           'that has a value!' if @value
    end

    # edge case applicable to I-FRAME-STREAM-INF tag only:
    #
    #    CODECS="first,second,etc"
    #
    # splitting via comma also splits the attribute value this leading to an
    # invalid attribute
    def handle_stream_inf(attributes)
      ec = ''
      attributes.split(',').each do | attr |
        if attr.count('"') == 1
          ec << attr << ','
          next unless ec.count('"') == 2
        end

        add_attribute(*attr.split('=')) if ec == ''

        if ec.count('"') == 2
          ec[-1] = ''
          add_attribute(*ec.split('='))
          ec = ''
        end
      end
    end
  end
end
