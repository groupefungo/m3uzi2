require_relative 'tag_definition'

module M3Uzi2
  # The EXT-X-SESSION-DATA tag allows arbitrary session data to be
  # carried in a Master Playlist.

  # Its format is:

  # EXT-X-SESSION-DATA:<attribute list>

  # The following attributes are defined:

  # DATA-ID
  # The value of DATA-ID is a quoted-string which identifies that data
  # value.  The DATA-ID SHOULD conform to a reverse DNS naming
  # convention, such as "com.example.movie.title".  This attribute is
  # REQUIRED.

  # VALUE
  # VALUE is a quoted-string.  It contains the data identified by DATA-
  # ID.  If the LANGUAGE is specified, VALUE SHOULD contain a human-
  # readable string written in the specified language.

  # URI
  # The value is a quoted-string containing a URI.  The resource
  # identified by the URI MUST be formatted as JSON [RFC7159]; otherwise,
  # clients may fail to interpret the resource.

  # LANGUAGE
  # The value is a quoted-string containing a language tag [RFC5646] that
  # identifies the language of the VALUE.  This attribute is OPTIONAL.

  # Each EXT-X-SESSION-DATA tag MUST contain either a VALUE or URI
  # attribute, but not both.

  # A Playlist MAY contain multiple EXT-X-SESSION-DATA tags with the same
  # DATA-ID attribute.  A Playlist MUST NOT contain more than one EXT-X-
  # SESSION-DATA tag with the same DATA-ID attribute and the same
  # LANGUAGE attribute.

  class EXT_X_SESSION_DATA < AttributeTag
    def initialize(tags, tn = 'EXT-X-SESSION-DATA')
      @min_version = 7
      @playlist_compatability = PlaylistCompatability::MASTER

      super(tags, tn)
    end

    def define_attributes
      @_ts.create_attributes(%w(DATA-ID VALIE URI LANGUAGE))
    end

    def define_constraints
    end

    def define_attribute_constraints
      required_attribute_constraint('DATA-ID')
      quoted_string_value_constraint('VALUE')
      quoted_string_value_constraint('URI')
      uri_value_constraint('URI')
      quoted_string_value_constraint('LANGUAGE')
    end

  end
end
