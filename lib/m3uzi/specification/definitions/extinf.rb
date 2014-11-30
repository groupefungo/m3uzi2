require_relative 'tag_definition'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-14
  # #section-4.3.2.1
  #
  #
  # The EXTINF tag specifies the duration of a Media Segment. It applies only
  # to the next Media Segment. This tag is REQUIRED for each Media Segment.
  # Its format is:

  # #EXTINF:<duration>,<title>

  # where duration is a decimal-integer or decimal-floating-point number (as
  # described in Section 4.2) that specifies the duration of the Media Segment
  # in seconds. Durations that are reported as integers SHOULD be rounded to
  # the nearest integer. Durations MUST be integers if the compatibility
  # version number is less than 3 to support older clients. Durations SHOULD
  # be floating-point if the compatibility version number is 3 or greater. The
  # remainder of the line following the comma is an optional human-readable
  # informative title of the Media Segment.
  class EXTINF < ValueTag
    def initialize(tags, tn = 'EXTINF')
      @playlist_compatability = PlaylistCompatability::MEDIA
      @min_version = 1

      super(tags, tn)
    end

    def define_constraints
      @_ts << TagConstraint.new('Invalid Value') do | tag |
        num = tag.value
        (pos = tag.value.to_s.index(',')) ? num = tag.value[0..pos - 1] : nil
        true if Float(num) rescue false
      end
    end
  end
end
