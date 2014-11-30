require_relative 'list_specification'

module M3Uzi2
  # ==== Description
  # A playlist tag is classed as any tag that can appear in an M3U8 file
  # which is not a header tag or media segment tag.
  class MediaPlaylistSpecification < ListSpecification
    def initialize
      self.class.tag_list =
        #%w( EXT-X-ENDLIST EXT-X-MEDIA EXT-X-STREAM-INF EXT-X-ENDLIST
            #EXT-X-DISCONTINUITY-SEQUENCE EXT-X-I-FRAMES-ONLY
            #EXT-X-I-FRAME-STREAM-INF EXT-X-INDEPENDENT-SEGMENTS )

        %w( EXTINF EXT-X-BYTERANGE EXT-X-KEY EXT-X-PROGRAM-DATE-TIME
            EXT-X-ENDLIST EXT-X-MEDIA EXT-X-STREAM-INF EXT-X-DISCONTINUITY
            EXT-X-I-FRAMES-ONLY EXT-X-MAP
            EXT-X-I-FRAME-STREAM-INF EXT-X-INDEPENDENT-SEGMENTS EXT-X-ENDLIST )

      super
    end
  end
end
