require_relative 'tag_definition'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # #section-3.4.16
  #
  # The EXT-X-INDEPENDENT-SEGMENTS tag indicates that all media samples
  # in a segment can be decoded without information from other segments.
  # It applies to every segment in the Playlist.
  #
  # Its format is:
  #
  # #EXT-X-INDEPENDENT-SEGMENTS
  #
  # This tag is OPTIONAL. It MUST NOT occur more than once.
  #
  # If the EXT-X-INDEPENDENT-SEGMENTS tag appears in a Master Playlist,
  #
  # it applies to every segment in every Media Playlist in the Master
  # Playlist.
  #
  # The EXT-X-INDEPENDENT-SEGMENTS tag appeared in version 6 of the
  # protocol.
  #
  class EXT_X_INDEPENDENT_SEGMENTS < IndependentTag
    def initialize(tags, tn = 'EXT-X-INDEPENDENT_SEGMENTS')
      @min_version = 6
      @playlist_compatability = PlaylistCompatability::MASTER

      super(tags, tn)
    end

    def define_constraints(ts)
      #valid_instance_constraint(ts, 0..INFINITY)
    end
  end
end
