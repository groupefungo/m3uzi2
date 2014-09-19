require_relative 'm3u8_tag_list'
require_relative 'specification/header_specification'

module M3Uzi2
  # Container for the header tags for both master and
  # media files.
  class M3U8Headers < M3U8TagList
    def initialize
      super()
    end

    def self.specification
      self._specification ||= HeaderSpecification.new
    end

    def self.valid_header?(tag)
      specification.valid_tag?(tag)
    end

    def increment_media_sequence(val = 1)
      self['EXT-X-MEDIA-SEQUENCE'][0].tap do | v |
        v ?  v.increment(val) : nil
      end
    end

    protected

    def add(tag)
      fail 'Only M3Uzi2::Tags may be added to headers' if super(tag).nil?
    end
  end
end
