require_relative 'tag_definition'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # #section-3.4.3

  # The EXT-X-DISCONTINUITY-SEQUENCE tag allows synchronization between
  # different Renditions of the same Variant Stream or different Variant
  # Streams that have EXT-X-DISCONTINUITY tags in their Media Playlists.

  # Its format is:

  # EXT-X-DISCONTINUITY-SEQUENCE:<number>

  # where number is a decimal-integer.

  # If the Media Playlist does not contain an EXT-X-DISCONTINUITY-
  # SEQUENCE tag, then the Discontinuity Sequence Number of the first
  # Media Segment in the Playlist SHALL be considered to be 0.

  # The EXT-X-DISCONTINUITY-SEQUENCE tag MUST appear before the first
  # Media Segment in the Playlist.

  # The EXT-X-DISCONTINUITY-SEQUENCE tag MUST appear before any EXT-
  # X-DISCONTINUITY tag.

  # See Section 6.2.1 and Section 6.2.2 for more information about
  # setting the value of the EXT-X-DISCONTINUITY-SEQUENCE tag.

  class EXT_X_DISCONTINUITY_SEQUENCE < ValueTag
    def initialize(tags, tn = 'EXT-X-DISCONTINUITY-SEQUENCE')
      @min_version = 6
      @playlist_compatability = PlaylistCompatability::MEDIA

      super(tags, tn)
    end

    def define_constraints
      integer_value_constraint
    end
  end
end
