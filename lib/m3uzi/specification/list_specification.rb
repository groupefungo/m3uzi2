require_relative 'tag_specification'

module M3Uzi2
  # Base methods for Playlist & Header specification classes.
  class ListSpecification
    class << self
      attr_accessor :tag_list
    end

    def initialize
      @tags = Hash[self.class.tag_list.product([nil])]
      define_tags
    end

    def [](key)
      @tags[key]
    end

    def valid_tag?(tag_name)
      self.class.tag_list.include?(tag_name)
    end

    def valid_attribute?(tag, attribute)
      valid_tag?(tag.name) &&
        @tags[tag.name].valid_attribute?(attribute)
    end

    # ==== Description
    # Define the tags for the playlist. Called from the base class
    # ListSpecification's initializer.
    def define_tags
      self.class.tag_list.each do | name |
        name = name.tr('-','_')
        require_relative "definitions/#{name.downcase}"
        Object.const_get("M3Uzi2::#{name}").new(@tags)
      end
    end

    def check_tag(tag)
      return false unless valid_tag?(tag.name)
      return false unless self[tag.name].valid?(tag)
      true
    end

    # def check_attribute(tag_name, attr_name, value = nil)
    def check_attribute(attr)
      tag = attr.parent_tag

      return warning "(Tag: #{tag.name}) "\
        "Invalid Attribute '#{attr.name}'" unless valid_attribute?(tag, attr)

      return warning "(Tag: #{tag.name}, Attribute: #{attr.name})"\
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
