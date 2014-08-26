require_relative 'tag_definition'
require 'uri'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # section-3.4.9

  # The EXT-X-MEDIA tag is used to relate Media Playlists that contain
  # alternative renditions of the same content.  For example, three
  # EXT-X-MEDIA tags can be used to identify audio-only Media Playlists
  # that contain English, French and Spanish renditions of the same
  # presentation.  Or two EXT-X-MEDIA tags can be used to identify video-
  # only Media Playlists that show two different camera angles.

  # The EXT-X-MEDIA tag stands alone, in that it does not apply to a
  # particular URI in the Master Playlist.  Its format is:

  # #EXT-X-MEDIA:<attribute-list>

  # The following attributes are defined:
  # NB: See spec for full definition

  # TYPE
  # URI
  # GROUP-ID
  # LANGUAGE
  # ASSOC-LANGUAGE
  # NAME
  # DEFAULT
  # AUTOSELECT
  # FORCED
  # INSTREAM-ID
  # CHARACTERISTICS

  # The EXT-X-MEDIA tag appeared in version 4 of the protocol.  The
  # EXT-X-MEDIA tag MUST NOT appear in a Media Playlist.

  class EXT_X_MEDIA < AttributeTag
    def initialize(tags, tn = 'EXT-X-MEDIA')
      @min_version = 4
      @playlist_compatability = PlaylistCompatability::MASTER

      super(tags, tn)
    end

    def define_constraints
    end

    def define_attributes
      @_ts.create_attributes(%w(TYPE URI GROUP-ID LANGUAGE ASSOC-LANGUAGE
                                NAME DEFAULT AUTOSELECT FORCED INSTREAM-ID
                                CHARACTERISTICS ))
    end

    def define_attribute_constraints
      required_attribute_constraints(%w(TYPE GROUP-ID NAME))

      restricted_attribute_value_constraint('TYPE', %w(AUDIO VIDEO SUBTITLES
                                                       CLOSED-CAPTIONS))

      value_excludes_attribute_constraint('TYPE', 'CLOSED-CAPTIONS', 'URI')

      quoted_string_value_constraints(%w(GROUP-ID LANGUAGE ASSOC-LANGUAGE
                                         CHARACTERISTICS))

      # TODO : CHARACTERISTICS - check if UTI
      restricted_attribute_value_constraints(%w(DEFAULT AUTOSELECT FORCED),
                                             %w(YES NO))

      # TODO: AUTOSELECT If it is present,
      # its value MUST be YES if the value of the DEFAULT attribute is YES.

      value_requires_attribute_constraint('TYPE', 'CLOSED-CAPTIONS',
                                          'INSTREAM-ID')
    end
  end
end
