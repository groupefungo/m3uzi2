require_relative 'm3u8_tag_list'
require_relative 'specification/header_specification'

module M3Uzi2
  # Container for the header tags for both master and media files.
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
      increment_sequence('EXT-X-MEDIA-SEQUENCE', val)
      self['EXT-X-MEDIA-SEQUENCE'][0].value
    end

    def increment_discontinuity_sequence(val = 1)
      increment_sequence('EXT-X-DISCONTINUITY-SEQUENCE', val)
      self['EXT-X-DISCONTINUITY-SEQUENCE'][0].value
    end

    def discontinuity_sequence
      self['EXT-X-DISCONTINUITY-SEQUENCE'].tap do | tags |
        return tags[0].value if tags
      end
      0.to_s
    end

    def media_sequence
      (ms = self['EXT-X-MEDIA-SEQUENCE']).empty? ? 0.to_s : ms[0].value
    end

    protected

    def add(tag)
      fail 'Only M3Uzi2::Tags may be added to headers' unless tag.kind_of?(Tag)
      fail "Invalid header #{tag.name}" unless self.class.valid_header?(tag.name)
      if has_tag_name?(tag.name)
        puts "Tag #{tag.name} already present in headers"
        return
      end

      super
    end

    def increment_sequence(name, val)
      add(Tag.new(name, '0')) unless has_tag_name?(name)
      self[name][0].tap { | v | v ? v.increment(val) : nil }
    end
  end
end
