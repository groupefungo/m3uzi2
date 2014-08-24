
require_relative 'tag_definition'
require 'uri'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # section-3.4.14

  # The EXT-X-MAP tag specifies how to obtain header information required
  # to parse the applicable media segments, such as the Transport Stream
  # PAT/PMT or the WebVTT header.  It applies to every media segment that
  # appears after it in the Playlist until the next EXT-X-DISCONTINUITY
  # tag, or until the end of the playlist.
  #
  # Its format is:
  #
  # #EXT-X-MAP:<attribute-list>
  #
  # The following attributes are defined:
  #
  # URI
  #
  # The value is a quoted-string containing a URI that identifies a
  # resource that contains segment header information.  This attribute is
  # REQUIRED.
  #
  # BYTERANGE
  #
  # The value is a quoted-string specifying a byte range into the
  # resource identified by the URI attribute.  This range SHOULD contain
  # only the header information.  The format of the byte range is
  # described in Section 3.4.1. This attribute is OPTIONAL; if it is not
  # present, the byte range is the entire resource indicated by the URI.
  #
  # An EXT-X-MAP tag SHOULD be supplied for media segments in Playlists
  # with the EXT-X-I-FRAMES-ONLY tag when the first media segment (ie:
  # I-frame) in the Playlist (or the first segment following an
  # EXT-X-DISCONTINUITY tag) does not immediately follow the PAT/PMT at
  # the beginning of its resource.
  #
  # The EXT-X-MAP tag appeared in version 5 of the protocol for use in
  # Media Playlist that contain the EXT-X-I-FRAMES-ONLY tag.  In protocol
  # version 6, it may appear in any Media Playlist.
  #
  class EXT_X_MAP < AttributeTag
    def initialize(tags, tn = 'EXT-X-MAP')
      super(tags, tn)
    end

    def define_attributes(ts)
      ts.create_attributes(%w(URI BYTERANGE))
    end

    def define_constraints(ts)
    end

    def define_attribute_constraints(ts)
    end

  end
end
