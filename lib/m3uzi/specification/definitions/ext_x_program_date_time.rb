
require_relative 'tag_definition'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # #section-3.4.5

  # The EXT-X-PROGRAM-DATE-TIME tag associates the first sample of a
  # Media Segment with an absolute date and/or time.  It applies only to
  # the next Media Segment.

  # The date/time representation is ISO/IEC 8601:2004 [ISO_8601] and
  # SHOULD indicate a time zone and fractional parts of seconds:

  # #EXT-X-PROGRAM-DATE-TIME:<YYYY-MM-DDThh:mm:ssZ>

  # For example:

  # #EXT-X-PROGRAM-DATE-TIME:2010-02-19T14:54:23.031+08:00

  # EXT-X-PROGRAM-DATE-TIME tags SHOULD provide millisecond accuracy.
  class EXT_X_PROGRAM_DATE_TIME < ValueTag
    def initialize(tags, tn = 'EXT-X-PROGRAM-DATE-TIME')
      @min_version = 1
      @playlist_compatability = PlaylistCompatability::MEDIA

      super(tags, tn)
    end

    def define_constraints
      date_value_constraint
    end
  end
end
