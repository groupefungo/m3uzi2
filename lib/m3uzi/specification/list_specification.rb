
module M3Uzi2
  # Base methods for Playlist & Header specification classes.
  class ListSpecification
    @@tags = []

    #class << self; attr_accessor :tag_list; end

    def initialize
      @tags = Hash[@@tags.product([nil])]
      define_tags
    end

    def [](key)
      return @tags[key]
    end

    def valid_tag?(tag)
      @@tags.include?(tag)
    end

    def valid_attribute?(tag, attribute)
      valid_tag?(tag.name) &&
        @tags[tag.name].valid_attribute?(tag, attribute)
    end

    def check_tag(tag)
      return warning("Invalid Tag '#{tag.name}'") unless valid_tag?(tag.name)

      unless self[tag.name].valid?(tag)
        return warning("(Tag: #{tag.name}) Invalid Value '#{tag.value}'")
      end
      true
    end

    # def check_attribute(tag_name, attr_name, value = nil)
    def check_attribute(attr)
      tag = attr.parent_tag

      return warning "(Tag: #{tag.name}) "\
        "Invalid Attribute '#{attr.name}'" unless valid_attribute?(tag, attr)

      return warning "(Tag: #{tag.name}, Attribute: #{attribute.name})"\
        " Invalid Value '#{attr.value}'" unless self[tag.name][attr.name]
          .valid?(attr)

      true
    end

    protected

    def warning(message)
      puts "WARNING! #{message}"
      false
    end
  end
end
