require_relative 'tag_definition'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # #section-3.4.2
  #

  # The EXT-X-TARGETDURATION tag specifies the maximum Media Segment
  # duration.  The EXTINF duration of each Media Segment in the Playlist
  # file, when rounded to the nearest integer, MUST be less than or equal
  # to the target duration; longer segments can trigger playback stalls
  # or other errors.  It applies to the entire Playlist file.  Its format
  # is:

  # #EXT-X-TARGETDURATION:<s>

  # where s is a decimal-integer indicating the target duration in
  # seconds.  The EXT-X-TARGETDURATION tag is REQUIRED.

  class EXT_X_TARGETDURATION < ValueTag
    def initialize(tags, tn = 'EXT-X-TARGETDURATION')
      @min_version = 1
      @playlist_compatability = PlaylistCompatability::MEDIA

      super(tags, tn)
    end

    def define_constraints
      integer_value_constraint
    end
  end
end
