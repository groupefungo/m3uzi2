require_relative 'tag_definition'
require 'uri'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # section-3.4.15
  #
  # The EXT-X-I-FRAME-STREAM-INF tag identifies a Media Playlist file
  # containing the I-frames of a multimedia presentation.  It stands
  # alone, in that it does not apply to a particular URI in the Master
  # Playlist.  Its format is:
  #
  # #EXT-X-I-FRAME-STREAM-INF:<attribute-list>
  #
  # All attributes defined for the EXT-X-STREAM-INF tag (Section 3.4.10)
  # are also defined for the EXT-X-I-FRAME-STREAM-INF tag, except for the
  # AUDIO, SUBTITLES and CLOSED-CAPTIONS attributes.  In addition, the
  # following attribute is defined:
  #
  # URI
  #
  # The value is a quoted-string containing a URI that identifies the
  # I-frame Playlist file.
  #
  # Every EXT-X-I-FRAME-STREAM-INF tag MUST include a BANDWIDTH attribute
  # and a URI attribute.
  #
  # The provisions in Section 3.4.10.1 also apply to EXT-X-I-FRAME-
  # STREAM-INF tags with a VIDEO attribute.
  #
  # A Master Playlist that specifies alternative VIDEO renditions and
  # I-frame Playlists SHOULD include an alternative I-frame VIDEO
  # rendition for each regular VIDEO rendition, with the same NAME and
  # LANGUAGE attributes.
  #
  # The EXT-X-I-FRAME-STREAM-INF tag appeared in version 4 of the
  # protocol.  Clients that do not implement protocol version 4 or higher
  # MUST ignore it.  The EXT-X-I-FRAME-STREAM-INF tag MUST NOT appear in
  # a Media Playlist.
  #

  class EXT_X_I_FRAME_STREAM_INF < AttributeTag
    def initialize(tags, tn = 'EXT-X-I-FRAME-STREAM-INF')
      @min_version = 4
      @playlist_compatability = PlaylistCompatability::MASTER

      super(tags, tn)
    end

    def define_attributes(ts)
      ts.create_attributes(%w(BANDWIDTH URI CODECS RESOLUTION VIDEO))
    end

    def define_constraints(ts)
    end

    def define_attribute_constraints(ts)
    end

  end
end
