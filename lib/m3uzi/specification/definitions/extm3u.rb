require_relative 'tag_definition'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # #section-3.3.1
  #
  # Note that this tag must also be the first line of the file. This is
  # checked by the file_parser
  class EXTM3U < IndependentTag
    def initialize(tags, tn = 'EXTM3U')
      @min_version = 1
      @playlist_compatability = PlaylistCompatability::BOTH

      super(tags, tn)
    end
  end
end
