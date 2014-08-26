require_relative 'tag_definition'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # #section-3.3.2
  #
  # The EXTINF tag specifies the duration of a media segment.  It applies
  # only to the media segment that follows it, and MUST be followed by a
  # media segment URI. Each media segment MUST be preceded by an EXTINF
  # tag.  Its format is:
  #
  # #EXTINF:<duration>,<title>
  #
  class EXTINF < ValueTag
    def initialize(tags, tn = 'EXTINF')
      # TODO: Check this
      @playlist_compatability = PlaylistCompatability::MEDIA
      @min_version = 1

      super(tags, tn)
    end

    def define_constraints
      @_ts << TagConstraint.new("Invalid Value") do | tag |
        num = tag.value
        (pos = tag.value.to_s.index(',')) ? num = tag.value[0..pos - 1] : nil
        true if Float(num) rescue false
      end
    end
  end
end
