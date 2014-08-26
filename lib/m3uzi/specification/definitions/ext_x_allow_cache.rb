require_relative 'tag_definition'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # #section-3.4.6
  #
  # The EXT-X-ALLOW-CACHE tag indicates whether the client MAY or MUST
  # NOT cache downloaded media segments for later replay.  It MAY occur
  # anywhere in a Media Playlist file; it MUST NOT occur more than once.
  # The EXT-X-ALLOW-CACHE tag applies to all segments in the playlist.
  # Its format is:
  #
  # #EXT-X-ALLOW-CACHE:<YES|NO>
  #
  # See Section 6.3.3 for more information on the EXT-X-ALLOW-CACHE tag.
  class EXT_X_ALLOW_CACHE < ValueTag
    def initialize(tags, tn = 'EXT-X-ALLOW-CACHE')
      @min_version = 1
      @playlist_compatability = PlaylistCompatability::BOTH

      super(tags, tn)
    end

    def define_constraints
      restricted_value_constraint(%w(YES NO))
    end
  end
end
