
require_relative 'tag_definition'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # #section-3.4.3
  #
  # The EXT-X-PLAYLIST-TYPE tag provides mutability information about the
  # Playlist file.  It applies to the entire Playlist file.  It is
  # OPTIONAL. Its format is:
  #
  # #EXT-X-PLAYLIST-TYPE:<EVENT|VOD>
  #
  # Section 6.2.1 defines the implications of the EXT-X-PLAYLIST-TYPE
  # tag.
  #
  # The EXT-X-PLAYLIST-TYPE tag MUST NOT appear in a Master Playlist.
  #
  class EXT_X_PLAYLIST_TYPE < ValueTag
    def initialize(tags, tn = 'EXT-X-PLAYLIST-TYPE')
      @min_version = 3
      @playlist_compatability = PlaylistCompatability::MEDIA

      super(tags, tn)
    end

    def define_constraints(ts)
      ts << TagConstraint.new('Value must be one of EVENT or VOD') do | tag |
        %w(EVENT VOD).include?(tag.value)
      end
    end
  end
end
