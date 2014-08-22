require_relative 'list_specification'
require_relative 'tag_specification'
require_relative 'definitions/playlist'

module M3Uzi2
  # ==== Description
  # TODO: Playlist is a temporary name.
  # A playlist is classed as any tag that can appear in an M3U8 file
  # which is not a file, stream or header tag.
  class PlaylistSpecification < ListSpecification
    def initialize
      self.class.tag_list =
        %w( EXTINF EXT-X-BYTERANGE EXT-X-KEY EXT-X-PROGRAM-DATE-TIME
            EXT-X-ENDLIST EXT-X-MEDIA EXT-X-STREAM-INF EXT-X-DISCONTINUITY
            EXT-X-DISCONTINUITY-SEQUENCE EXT-X-I-FRAMES-ONLY EXT-X-MAP
            EXT-X-I-FRAME-STREAM-INF EXT-X-INDEPENDENT-SEGMENTS )
      super
    end

    private

    # ==== Description
    # Define the tags for the playlist. Called from the base class
    # ListSpecification's initializer.
    def define_tags
      # TODO - just loop through the tag list requiring and creating
      EXT_X_KEY.new(@tags)
      EXTINF.new(@tags)
    end
  end
end

if $PROGRAM_NAME == __FILE__
  include M3Uzi2

  PlaylistSpecification.new
end
