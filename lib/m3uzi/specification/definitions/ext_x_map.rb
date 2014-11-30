
require_relative 'tag_definition'
require 'uri'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # section-3.4.14

  # The EXT-X-MAP tag specifies how to obtain the Media Initialization
  # Section (Section 3) required to parse the applicable Media Segments.
  # It applies to every Media Segment that appears after it in the
  # Playlist until the next EXT-X-MAP tag or until the end of the
  # playlist.

  # Its format is:

  # #EXT-X-MAP:<attribute-list>

  # The following attributes are defined:

  # URI

  # The value is a quoted-string containing a URI that identifies a
  # resource that contains the Media Initialization Section.  This
  # attribute is REQUIRED.

  # BYTERANGE

  # The value is a quoted-string specifying a byte range into the
  # resource identified by the URI attribute.  This range SHOULD contain
  # only the Media Initialization Section.  The format of the byte range
  # is described in Section 4.3.2.2.  This attribute is OPTIONAL; if it
  # is not present, the byte range is the entire resource indicated by
  # the URI.

  # An EXT-X-MAP tag SHOULD be supplied for Media Segments in Playlists
  # with the EXT-X-I-FRAMES-ONLY tag when the first Media Segment (i.e.,
  # I-frame) in the Playlist (or the first segment following an EXT-
  # X-DISCONTINUITY tag) does not immediately follow the Media
  # Initialization Section at the beginning of its resource.

  # Use of the EXT-X-MAP tag in a Media Playlist that does not contain
  # the EXT-X-I-FRAMES-ONLY tag REQUIRES a compatibility version number
  # of 6 or greater; otherwise, a compatibility version number of 5 or
  # greater is REQUIRED.

  class EXT_X_MAP < AttributeTag
    def initialize(tags, tn = 'EXT-X-MAP')
      @min_version = 5
      @playlist_compatability = PlaylistCompatability::MEDIA

      super(tags, tn)
    end

    def define_attributes
      @_ts.create_attributes(%w(URI BYTERANGE))
    end

    def define_constraints
    end

    def define_attribute_constraints
      required_attribute_constraint('URI')
      quoted_string_value_constraint('BYTERANGE')
      byte_range_attribute_constraint('BYTERANGE')
    end

  end
end
