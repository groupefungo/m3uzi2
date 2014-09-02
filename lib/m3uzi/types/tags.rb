require_relative '../error_handler'

module M3Uzi2
  class Tags < Hash; end

  class Tag
    include ErrorHandler

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

    def add_attributes(attributes)
      return handle_stream_inf(attributes) if name == 'EXT-X-I-FRAME-STREAM-INF'

      Attributes.parse(attributes) do | n, v |
        add_attribute(n, v)
      end
    end

    def [](key)
      @attributes[key]
    end

    def []=(key, value)
      @attributes[key] = value
    end

    def add_attribute(name, value)
      fail "Cannot add attributes to a #{self.class.name} that has a value!" if @value
      @attributes[name] = M3Uzi2::Attribute.new(self, name, value)
    end

    def valid?
      @specification.check_tag(self) && @attributes.all? { | k, v | v.valid? }
    end

    def to_s
      "##{@name}#{@value || @attributes.size > 0 ? ':' : ''}#{@attributes}#{@value}"
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

    def value=(val)
      fail "Cannot set a value on a #{self.class.name} that has attributes!" if @attributes.size > 0
      @value = val
    end

    private

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
