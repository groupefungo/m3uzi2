require_relative 'types/tags'

module M3Uzi2

  # Base class for Headers and Playlist
  class M3U8TagList
    include Enumerable

    def initialize
      @_lines = []
    end

    def [](key)
      @_lines.select { | tag | tag.name == key }
    end


    def <<(tag)
      add(tag)
    end

    def self.create_tag(name, attributes, value)
      tag = M3Uzi2::Tag.new(name, value)

      attributes.split(',').each do | attr |
        tag.add_attribute(*attr.split('='))
      end if attributes

      return tag
    end

    def each
      return enum_for(:each) unless block_given?
      @_lines.each { |e| yield(e) }
    end

    def to_s
      @_lines.to_s
    end
  end

end
