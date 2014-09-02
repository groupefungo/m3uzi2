require_relative 'tag_definition'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # #section-3.4.11
  #
  #  The EXT-X-DISCONTINUITY tag indicates an encoding discontinuity
  #  between the media segment that follows it and the one that preceded
  #  it.  The set of characteristics that MAY change is:
  #
  #  o  file format
  #  o  number and type of tracks
  #  o  encoding parameters
  #  o  encoding sequence
  #  o  timestamp sequence
  #
  #  Its format is:
  #
  #  #EXT-X-DISCONTINUITY
  #
  #  See Section 4, Section 6.2.1, and Section 6.3.3 for more information
  #  about the EXT-X-DISCONTINUITY tag.
  #
  #  The EXT-X-DISCONTINUITY tag MUST NOT appear in a Master Playlist.
  #
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
