require_relative 'list_specification'

module M3Uzi2
  class HeaderSpecification < ListSpecification
    def initialize
      self.class.tag_list =
        %w( EXTM3U EXT-X-TARGETDURATION EXT-X-PLAYLIST-TYPE EXT-X-VERSION
            EXT-X-MEDIA-SEQUENCE EXT-X-ALLOW-CACHE EXT-X-START )
      super
    end
  end
end

