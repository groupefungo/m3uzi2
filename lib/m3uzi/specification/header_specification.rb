require_relative 'list_specification'
require_relative 'definitions/headers'

module M3Uzi2
  class HeaderSpecification < ListSpecification
    @@_tags = %w(EXT-X-TARGETDURATION
                 EXT-X-PLAYLIST-TYPE
                 EXT-X-VERSION
                 EXT-X-MEDIA-SEQUENCE
                 EXT-X-ALLOW-CACHE
                 EXT-X-START
    )

    private

    def define_tags
      #define_ext_x_targetduration
      #define_ext_x_playlist_type
      #define_ext_x_version
      #define_ext_x_media_sequence
      #define_ext_x_allow_cache
      #define_ext_x_start
    end
  end
end

