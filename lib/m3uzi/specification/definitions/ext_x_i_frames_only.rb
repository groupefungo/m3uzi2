require_relative 'tag_definition'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # #section-3.4.13
  #
  #
  # The EXT-X-I-FRAMES-ONLY tag indicates that each Media Segment in the
  # Playlist describes a single I-frame.  I-frames (or Intra frames) are
  # encoded video frames whose encoding does not depend on any other
  # frame.

  # The EXT-X-I-FRAMES-ONLY tag applies to the entire Playlist.  Its
  # format is:

  # #EXT-X-I-FRAMES-ONLY

  # In a Playlist with the EXT-X-I-FRAMES-ONLY tag, the Media Segment
  # duration (EXTINF tag value) is the time between the presentation time
  # of the I-frame in the Media Segment and the presentation time of the
  # next I-frame in the Playlist, or the end of the presentation if it is
  # the last I-frame in the Playlist.

  # Media resources containing I-frame segments MUST begin with either a
  # Media Initialization Section (Section 3) or be accompanied by an EXT-
  # X-MAP tag indicating the Media Initialization Section so that clients
  # can load and decode I-frame segments in any order.  The byte range of
  # an I-frame segment with an EXT-X-BYTERANGE tag applied to it
  # (Section 4.3.2.2) MUST NOT include its Media Initialization Section;
  # clients can assume that the Media Initialization Section is defined
  # by EXT-X-MAP tag, or is located from the start of the resource to the
  # offset of the first I-frame segment in that resource.

  # Use of the EXT-X-I-FRAMES-ONLY REQUIRES a compatibility version
  # number of 4 or greater.
  class EXT_X_I_FRAMES_ONLY < IndependentTag
    def initialize(tags, tn = 'EXT-X-I-FRAMES-ONLY')
      @min_version = 4
      @playlist_compatability = PlaylistCompatability::MEDIA

      super(tags, tn)
    end

    def define_constraints
#      valid_instance_constraint(ts, 0..INFINITY)
    end
  end
end
