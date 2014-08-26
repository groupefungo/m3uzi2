require_relative 'tag_definition'
require 'uri'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # section-3.4.10
  #
  # The EXT-X-STREAM-INF tag specifies a variant stream, which is a set
  # of renditions which can be combined to play the presentation.  The
  # attributes of the tag provide information about the variant stream.
  #
  # The EXT-X-STREAM-INF tag identifies the next URI line in the Playlist
  # as a rendition of the variant stream.
  #
  # The EXT-X-STREAM-INF tag MUST NOT appear in a Media Playlist.
  #
  # Its format is:
  #
  # #EXT-X-STREAM-INF:<attribute-list>
  # <URI>
  #
  # The following attributes are defined:
  # NB: See Spec for full definition:
  #
  # BANDWIDTH
  # Every EXT-X-STREAM-INF tag MUST include the BANDWIDTH attribute.
  #
  # CODECS
  # Every EXT-X-STREAM-INF tag SHOULD include a CODECS attribute.
  #
  # RESOLUTION
  # The RESOLUTION attribute is OPTIONAL but is recommended if the
  # variant stream includes video.
  #
  # AUDIO
  # The AUDIO attribute is OPTIONAL.
  #
  # VIDEO
  # The VIDEO attribute is OPTIONAL.
  #
  # SUBTITLES
  # The SUBTITLES attribute is OPTIONAL.
  #
  # CLOSED-CAPTIONS
  # The CLOSED-CAPTIONS attribute is OPTIONAL.
  #

  class EXT_X_STREAM_INF < AttributeTag
    def initialize(tags, tn = 'EXT-X-STREAM-INF')
      @min_version = 1
      @playlist_compatability = PlaylistCompatability::MASTER

      super(tags, tn)
    end

    def define_attributes
      @_ts.create_attributes(%w(BANDWIDTH CODECS RESOLUTION AUDIO VIDEO
                                SUBTITLES CLOSED-CAPTIONS))
    end

    def define_constraints

    end

    def define_attribute_constraints
      required_attribute_constraint('BANDWIDTH')
      integer_value_constraint('BANDWIDTH')
      quoted_string_value_constraints(%w(CODECS AUDIO VIDEO SUBTITLES))
      decimal_resolution_value_constraint('RESOLUTION')
    end

  end
end
