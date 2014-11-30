require_relative 'tag_definition'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # #section-3.4.8

  # The EXT-X-ENDLIST tag indicates that no more Media Segments will be
  # added to the Media Playlist file.  It MAY occur anywhere in the Media
  # Playlist file.  Its format is:

  # #EXT-X-ENDLIST
  class EXT_X_ENDLIST < IndependentTag
    def initialize(tags, tn = 'EXT-X-ENDLIST')
      @min_version = 1
      @playlist_compatability = PlaylistCompatability::MEDIA

      super(tags, tn)
    end

    def define_constraints
      valid_occurance_constraint((0..INFINITY))
    end
  end
end
