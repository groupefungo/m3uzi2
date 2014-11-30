require_relative 'types/tags'
require_relative 'types/attributes'
require_relative 'types/media_segment'

module M3Uzi2
  # Base class for Headers and Playlist
  class M3U8TagList
    include Enumerable

    def initialize
      @_lines = []
    end

    def [](key)
      @_lines.select { | tag | tag.kind_of?(Tag) && tag.name == key }
    end

    def <<(tag)
      add(tag)
    end

    def delete(tag)
      @_lines.delete(tag)
    end


    def clear!
      @_lines.clear
    end

    def each
      return enum_for(:each) unless block_given?
      @_lines.each { | e | yield(e) }
    end

    def add(tag)
      return nil unless tag.kind_of? Tag

      if tag.specification.nil?
        tag.specification = self.class.specification
      end

      tag.valid?

      return @_lines << tag
    end

    def index(tag)
      (i = @_lines.index(tag)) ? i : 0
    end

    def item_at(index)
      @_lines[index]
    end

    def to_s
      @_lines.to_s
    end

    def self.create_tag(name, attributes, value)
      tag = Tag.new(name, value)
      tag.add_attributes(attributes) unless attributes.nil?

      return tag
    end

    protected

    class << self
      attr_accessor :_specification
    end
  end
end
