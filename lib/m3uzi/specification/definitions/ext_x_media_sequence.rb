require_relative 'tag_definition'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # #section-3.4.3
  #
  #  Each media segment in a Playlist has a unique integer sequence
  #  number.  The sequence number of a segment is equal to the sequence
  #  number of the segment that preceded it plus one.  The EXT-X-MEDIA-
  #  SEQUENCE tag indicates the sequence number of the first segment that
  #  appears in a Playlist file.  Its format is:
  #
  #  #EXT-X-MEDIA-SEQUENCE:<number>
  #
  #  where number is a decimal-integer.  The sequence number MUST NOT
  #  decrease.
  #
  #  A Media Playlist file MUST NOT contain more than one EXT-X-MEDIA-
  #  SEQUENCE tag.  If the Media Playlist file does not contain an EXT-X
  #  -MEDIA-SEQUENCE tag then the sequence number of the first segment in
  #  the playlist SHALL be considered to be 0.  A client MUST NOT assume
  #  that segments with the same sequence number in different Media
  #  Playlists contain matching content.
  #
  #  A media URI is not required to contain its sequence number.
  #
  # See Section 6.2.1, Section 6.3.2 and Section 6.3.5 for information on
  # handling the EXT-X-MEDIA-SEQUENCE tag.
  #
  # The EXT-X-MEDIA-SEQUENCE tag MUST appear before the first media
  # segment in the Playlist.
  #
  # The EXT-X-MEDIA-SEQUENCE tag MUST NOT appear in a Master Playlist.
  #
  class EXT_X_MEDIA_SEQUENCE < ValueTag
    def initialize(tags, tn = 'EXT-X-MEDIA-SEQUENCE')
      super(tags, tn)
    end

    def define_constraints(ts)
      integer_value_constraint(ts)
    end
  end
end
