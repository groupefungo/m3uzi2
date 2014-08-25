require_relative 'tag_definition'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # #section-3.4.13
  #
  # The EXT-X-I-FRAMES-ONLY tag indicates that each media segment in the
  # Playlist describes a single I-frame.  I-frames (or Intra frames) are
  # encoded video frames whose encoding does not depend on any other
  # frame.
  #
  # The EXT-X-I-FRAMES-ONLY tag applies to the entire Playlist.  Its
  # format is:
  #
  # EXT-X-I-FRAMES-ONLY
  #
  # In a Playlist with the EXT-X-I-FRAMES-ONLY tag, the media segment
  # duration (EXTINF tag value) is the time between the presentation time
  # of the I-frame in the media segment and the presentation time of the
  # next I-frame in the Playlist, or the end of the presentation if it is
  # the last I-frame in the Playlist.
  #
  # Media resources containing I-frame segments MUST begin with either a
  # Transport Stream PAT/PMT or be accompanied by an EXT-X-MAP tag
  # indicating the proper PAT/PMT. The byte range of an I-frame segment
  # with an EXT-X-BYTERANGE tag applied to it (Section 3.4.1) MUST NOT
  # include a PAT/PMT.
  #
  # The EXT-X-I-FRAMES-ONLY tag appeared in version 4 of the protocol.
  # The EXT-X-I-FRAMES-ONLY tag MUST NOT appear in a Master Playlist.
  #
  class EXT_X_I_FRAMES_ONLY < IndependentTag
    def initialize(tags, tn = 'EXT_X_I_FRAMES_ONLY')
      @min_version = 4
      @playlist_compatability = PlaylistCompatability::MEDIA

      super(tags, tn)
    end

    def define_constraints(ts)
#      valid_instance_constraint(ts, 0..INFINITY)
    end
  end
end
