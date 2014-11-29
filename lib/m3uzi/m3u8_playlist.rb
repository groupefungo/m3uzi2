require_relative 'm3u8_tag_list'
require_relative 'specification/playlist_specification'

module M3Uzi2
  # TODO: Rename to MediaPlaylist
  class M3U8Playlist < M3U8TagList
    def initialize
      super()
    end

    def self.specification
      self._specification ||= MediaPlaylistSpecification.new
    end

    def self.valid_tag?(tag)
      specification.valid_tag?(tag)
    end

    # Convenience method to create a new MediaSegment.
    # TODO: Deprecate in favour of the instance method
    def self.create_media_segment(path)
      MediaSegment.new(path)
    end

    def create_media_segment(path)
      MediaSegment.new(path, self)
    end

    # Returns true if the playlist contains the final media segment
    def final_media_segment?
      !self['EXT-X-ENDLIST'].empty?
    end

    # returns the total duration of all media_segments (as indicated by
    # the cumulative length of the 'EXT-X-INF' tags).
    def total_duration
      media_segments.reduce(0.0) do | a, e |
        a + e.duration
      end
    end

    def media_segment(filename)
      @_lines.select { | tag | tag.kind_of?(MediaSegment) && tag.path == filename}[0]
    end

    # Returns all the media segments.
    def media_segments
      @_lines.select { | tag | tag.kind_of?(MediaSegment) }
    end

    # Remove a media segment ensuring that any tags which apply to that
    # segment are also removed.
    def delete_media_segment(filename, idx = 0)
      @_lines.each do | tag |
        idx += 1
        next unless tag.kind_of? MediaSegment

        if tag.value == filename
          # TODO: Need to limit this, check to what, and then just
          # delete the applicable_tags
          #
          @_lines.delete_at(idx - 2) while @_lines[idx - 2].kind_of?(Tag)
          @_lines.delete(tag)
          return true
        end
      end
      false
    end

    protected

    def add(tag)

      if super(tag).nil?
        if tag.kind_of?(MediaSegment)
          # all tags in the media segment should be in the playlist and
          # all tags in the playlist which apply to the media segment should
          # point to the media segment AND be in the segment_tags list
          tag.applicable_tags(self).each do | seg_tag |
            tag.add_segment_tag(seg_tag) unless tag.has_tag(seg_tag)
            seg_tag.media_segment = self
          end
          return @_lines << tag
        end

        fail 'Only M3Uzi2::Tags or MediaSegments may be added to playlist'
      end
    end
  end
end
