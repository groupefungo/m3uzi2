# require 'enumerable'
module M3Uzi2
  # Generic Collection Type
  class HashCollection
    include Enumerable
    def initialize
      @members = {}
    end

    def [](key)
      return @members[key]
    end

    def []=(key, val)
      @members[key] =  val
    end

    def each(&block)
      @members.each(&block)
    end
  end

  class Tags < HashCollection; end
  class Attributes < HashCollection; end

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
      fail "Cannot add attributes to a #{self.class.name} that has a value!" if @value
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
      fail "Cannot set a value on a #{self.class.name} that has attributes!" if @attributes.size > 0
      @value = val
    end
  end

  # MediaSegment is out workhorse for the most part. A segment is what was
  # described as a file
  class MediaSegment
    attr_accessor :path # path, filename or URI

    # validate_presence should check if the file exists
    def initialize(path, validate_presence = false)
      @path = path
    end

    def valid?
      true

    end
  end
end
