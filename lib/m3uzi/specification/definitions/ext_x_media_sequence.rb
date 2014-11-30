require_relative 'tag_definition'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # #section-3.4.3
  #

  # The EXT-X-MEDIA-SEQUENCE tag indicates the Media Sequence Number of
  # the first Media Segment that appears in a Playlist file.  Its format
  # is:

  # #EXT-X-MEDIA-SEQUENCE:<number>

  # where number is a decimal-integer.

  # If the Media Playlist file does not contain an EXT-X-MEDIA-SEQUENCE
  # tag then the Media Sequence Number of the first Media Segment in the
  # playlist SHALL be considered to be 0.  A client MUST NOT assume that
  # segments with the same Media Sequence Number in different Media
  # Playlists contain matching content - see Section 6.3.2.

  # A URI for a Media Segment is not required to contain its Media
  # Sequence Number.

  # See Section 6.2.1 and Section 6.3.5 for more information on setting
  # the EXT-X-MEDIA-SEQUENCE tag.

  # The EXT-X-MEDIA-SEQUENCE tag MUST appear before the first Media
  # Segment in the Playlist.
  class EXT_X_MEDIA_SEQUENCE < ValueTag
    def initialize(tags, tn = 'EXT-X-MEDIA-SEQUENCE')
      @min_version = 1
      @playlist_compatability = PlaylistCompatability::MEDIA

      super(tags, tn)
    end

    def define_constraints
      integer_value_constraint
    end
  end
end
