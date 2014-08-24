require_relative 'tag_definition'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # #section-3.4.3
  #
  # The EXT-X-DISCONTINUITY-SEQUENCE tag allows synchronization between
  # different renditions of the same variant stream or different variant
  # streams that have EXT-X-DISCONTINUITY tags in their Media Playlists.
  #
  # Its format is:
  #
  # #EXT-X-DISCONTINUITY-SEQUENCE:<number>
  #
  # where number is a decimal-integer.  The discontinuity sequence number
  # MUST NOT decrease.
  #
  # A Media Playlist MUST NOT contain more than one EXT-X-DISCONTINUITY-
  # SEQUENCE tag.  If the Media Playlist does not contain an EXT-X
  # -DISCONTINUITY-SEQUENCE tag, then the discontinuity sequence number
  # of the first segment in the playlist SHALL be considered to be 0.
  #
  # The EXT-X-DISCONTINUITY-SEQUENCE tag MUST appear before the first
  # media segment in the Playlist.
  #
  # The EXT-X-DISCONTINUITY-SEQUENCE tag MUST appear before any
  # EXT-X-DISCONTINUITY tag.
  #
  # A media playlist MUST NOT contain a EXT-X-DISCONTINUITY-SEQUENCE if
  # its EXT-X-PLAYLIST-TYPE is VOD or EVENT.
  #
  # An EXT-X-DISCONTINUITY-SEQUENCE tag MUST ONLY appear in a Media
  # Playlist.
  #
  # See Section 6.2.1 and Section 6.2.2 for more information about the
  # EXT-X-DISCONTINUITY-SEQUENCE tag.
  #
  class EXT_X_DISCONTINUITY_SEQUENCE < ValueTag
    def initialize(tags, tn = 'EXT-X-DISCONTINUITY-SEQUENCE')
      super(tags, tn)
    end

    def define_constraints(ts)
      integer_value_constraint(ts)
    end
  end
end
