require_relative 'tag_definition'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # #section-3.4.1
  #
  # The EXT-X-BYTERANGE tag indicates that a media segment is a sub-range
  # of the resource identified by its media URI. It applies only to the
  # next media URI that follows it in the Playlist.  Its format is:
  #
  # #EXT-X-BYTERANGE:<n>[@<o>]
  #
  # where n is a decimal-integer indicating the length of the sub-range
  # in bytes.  If present, o is a decimal-integer indicating the start of
  # the sub-range, as a byte offset from the beginning of the resource.
  # If o is not present, the sub-range begins at the next byte following
  # the sub-range of the previous media segment.
  #
  # If o is not present, a previous media segment MUST appear in the
  # Playlist file and MUST be a sub-range of the same media resource.
  #
  # A media URI with no EXT-X-BYTERANGE tag applied to it specifies a
  # media segment that consists of the entire resource.
  #
  # The EXT-X-BYTERANGE tag appeared in version 4 of the protocol.  It
  # MUST NOT appear in a Master Playlist.
  #
  class EXT_X_BYTERANGE < ValueTag
    def initialize(tags, tn = 'EXT-X-BYTERANGE')
      @min_version = 4
      @playlist_compatability = PlaylistCompatability::MEDIA

      super(tags, tn)
    end

    def define_constraints(ts)
      ts << Constraint.new("Invalid Value") do | tag |
        length = tag.value
        start = 0

        if (pos = tag.value.to_s.index('@'))
          length, start = [tag.value[0..pos - 1], tag.value[pos + 1..-1]]
        end

        begin
          Integer(length) && Integer(start)
        rescue
          false
        end
      end
    end
  end
end
