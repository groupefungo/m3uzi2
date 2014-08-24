require_relative 'tag_definition'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # #section-3.4.2
  #
  # The EXT-X-TARGETDURATION tag specifies the maximum media segment
  # duration.  The EXTINF duration of each media segment in the Playlist
  # file, when rounded to the nearest integer, MUST be less than or equal
  # to the target duration.  This tag MUST appear once in a Media
  # Playlist file.  It applies to the entire Playlist file.  Its format
  # is:
  #
  # #EXT-X-TARGETDURATION:<s>
  #
  # where s is a decimal-integer indicating the target duration in
  # seconds.
  #
  # The EXT-X-TARGETDURATION tag MUST NOT appear in a Master Playlist.
  #
  class EXT_X_TARGETDURATION < ValueTag
    def initialize(tags, tn = 'EXT-X-TARGETDURATION')
      super(tags, tn)
    end

    def define_constraints(ts)
      integer_value_constraint(ts)
    end
  end
end
