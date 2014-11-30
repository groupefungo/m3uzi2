require_relative 'm3u8_tag_list'
require_relative 'specification/playlist_specification'

module M3Uzi2
  class MediaPlaylist < M3U8TagList
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

    # ==== Description
    # Create a new media segment, setting path to +path+ and the playlist
    # of the media segment to self.
    def create_media_segment(path)
      MediaSegment.new(path, self)
    end

    # ==== Description
    # Returns true if the playlist contains the final media segment
    def final_media_segment?
      !self['EXT-X-ENDLIST'].empty?
    end

    # ==== Description
    # returns the total duration of all media_segments (as indicated by
    # the cumulative length of the 'EXT-X-INF' tags).
    def total_duration
      media_segments.reduce(0.0) do | a, e |
        a + e.duration
      end
    end

    # ==== Description
    # Given a filename will return a single media segment or nil
    def media_segment(filename)
      media_segments.select { | tag | tag.path == filename}[0] || nil
    end

    # ==== Description
    # Returns all the media segments.
    def media_segments
      @_lines.select { | tag | tag.kind_of?(MediaSegment) }
    end

    # ==== Description
    # Given a filename, delete a media segment ensuring that any tags which
    # apply to that segment are also removed.
    #
    # Returns false if the media segment +filename+ was not present, true
    # if the segment was deleted.
    def delete_media_segment(filename)
      return false unless (ms = media_segment(filename))
      ms.delete
      true
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
            ller
          end
          return @_lines << tag
        end

        fail 'Only M3Uzi2::Tags or MediaSegments may be added to playlist'
      end
    end
  end
end
