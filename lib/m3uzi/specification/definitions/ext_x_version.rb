require_relative 'tag_definition'

module M3Uzi2
# http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
# #section-3.4.18
  #
# The EXT-X-VERSION tag indicates the compatibility version of the
# Playlist file.  The Playlist file, its associated media, and its
# server MUST comply with all provisions of the most-recent version of
# this document describing the protocol version indicated by the tag
# value.
#
# The EXT-X-VERSION tag applies to the entire Playlist file.  Its
# format is:
#
# #EXT-X-VERSION:<n>
#
# where n is an integer indicating the protocol version.
#
# A Playlist file MUST NOT contain more than one EXT-X-VERSION tag.  A
# Playlist file that does not contain an EXT-X-VERSION tag MUST comply
# with version 1 of this protocol.
#
# The EXT-X-VERSION tag MAY appear in either Master Playlist or Media
# Playlist.  It MUST appear in all playlists containing tags or
# attributes that are not compatible with protocol version 1.
  #
  class EXT_X_VERSION < ValueTag
    def initialize(tags, tn = 'EXT-X-VERSION')
      super(tags, tn)
    end

    def define_constraints(ts)
      integer_value_constraint(ts)
    end
  end
end
