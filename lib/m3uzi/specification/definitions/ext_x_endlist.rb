require_relative 'tag_definition'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # #section-3.4.8
  #
  # The EXT-X-ENDLIST tag indicates that no more media segments will be
  # added to the Media Playlist file.  It MAY occur anywhere in the
  # Playlist file; it MUST NOT occur more than once.  Its format is:
  #
  # #EXT-X-ENDLIST
  #
  # The EXT-X-ENDLIST tag MUST NOT appear in a Master Playlist.
  #
  class EXT_X_ENDLIST < IndependentTag
    def initialize(tags, tn = 'EXT-X-ENDLIST')
      super(tags, tn)
    end

    def define_constraints(ts)
      valid_instance_constraint(ts, 0..1)
    end
  end
end
