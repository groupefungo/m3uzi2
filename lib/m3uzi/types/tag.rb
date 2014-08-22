#require 'enumerable'
module M3Uzi2

  class Attributes
    include Enumerable
    def initialize
      @attributes = {}
    end

    def [](key)
      return @attributes[key]
    end

    def []=(key, val)
      @attributes[key] =  val
    end


    def each(&block)
      @attributes.each(&block)
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

    def valid?
      $plt.check_attribute(self)
    end
  end

  class Tag
    # FULL NAME INCLUDING THE EXT-X
    attr_reader :name,
                :value,
                :attributes

    def initialize(name, value = nil)
      @name = name
      @value = value

      @attributes = M3Uzi2::Attributes.new
    end

    def add_attribute(name, value)
      @attributes[name] = nil
      @attributes[name] = M3Uzi2::Attribute.new(self, name, value)
    end

    def valid?
      $plt.check_tag(self) && @attributes.all? do | k, v |
        v.valid?
      end
    end

    def format
      "##{@name}:#{@value}"
    end

    def value=(val)
      @value = val
    end
  end

  class Tags
    include Enumerable

    def initialize
      @tags = {}
    end

    def [](key)
      return @tags[key]
    end

    def each(&block)
      @tags.each(&block)
    end
  end

  class MediaSegment
    attr_accessor :segment # path, filename or URI

    # validate_presence should check if the file exists
    def initialize(segment, validate_presence = false)
      @tags = Tags.new
      @segment = segment
    end

    def add_tag(name, value)
      @tags[name] = M3Uzi2::Tag.new(name, value)
    end
  end
end
