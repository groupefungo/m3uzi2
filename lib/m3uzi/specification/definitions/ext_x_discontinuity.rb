require_relative 'tag_definition'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # #section-4.3.2.3

  # The EXT-X-DISCONTINUITY tag indicates a discontinuity between the Media
  # Segment that follows it and the one that preceded it.

  # Its format is:
  #
  # #EXT-X-DISCONTINUITY
  #
  # The EXT-X-DISCONTINUITY tag MUST be present if there is a change in any of
  # the following characteristics:
  #
  # - file format
  # - number, type and identifiers of tracks
  # - timestamp sequence

  # The EXT-X-DISCONTINUITY tag SHOULD be present if there is a change in any
  # of the following characteristics:

  # - encoding parameters
  # - encoding sequence
  class EXT_X_DISCONTINUITY < IndependentTag
    def initialize(tags, tn = 'EXT-X-DISCONTINUITY')
      @min_version = 1
      @playlist_compatability = PlaylistCompatability::MEDIA

      super(tags, tn)
    end

    def define_constraints
      valid_occurance_constraint((0..INFINITY))
    end
  end
end
