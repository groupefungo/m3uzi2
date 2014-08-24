require_relative 'types/tag'

module M3Uzi2
  # Base class for Headers and Playlist
  class M3U8TagList
    def initialize
      @_lines = []
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

    def to_s
      @_lines.to_s
    end
  end

end
