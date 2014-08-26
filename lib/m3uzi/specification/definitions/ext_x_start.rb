
require_relative 'tag_definition'
require 'uri'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # section-3.4.10
  #
  # The EXT-X-START tag indicates a preferred point at which to start
  # playing a Playlist.  By default, clients SHOULD start playback at
  # this point when beginning a playback session.  It MUST NOT appear
  # more than once in a Playlist.  This tag is OPTIONAL.
  #
  # If the EXT-X-START tag appears in a Master Playlist, it indicates the
  # preferred starting point of every Media Playlist in the Master
  # Playlist.  If this tag appears in a Media Playlist that is referenced
  # by a Master Playlist, then every other Media Playlist in the Master
  # Playlist MUST also contain an EXT-X-START tag with the same
  # attributes and values.
  #
  # Its format is:
  #
  # #EXT-X-START:<attribute list>
  #
  # The following attributes are defined:
  #
  # TIME-OFFSET
  # PRECISE
  #
  # The EXT-X-START tag appeared in version 6 of the protocol.
  #

  class EXT_X_START < AttributeTag
    def initialize(tags, tn = 'EXT-X-START')
      @min_version = 6
      @playlist_compatability = PlaylistCompatability::BOTH

      super(tags, tn)
    end

    def define_attributes
      @_ts.create_attributes(%w(TIME-OFFSET PRECISE))
    end

    def define_constraints
      required_attribute_constraint('TIME-OFFSET')
    end

    def define_attribute_constraints
      restricted_attribute_value_constraint('PRECISE', %w(YES NO))
    end
  end
end
