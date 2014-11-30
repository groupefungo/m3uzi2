require_relative 'list_specification'

module M3Uzi2
  # ==== Description
  #   EXTINF                  - applies only to this media segment
  #   EXT-X-PROGRAM-DATE-TIME - appplies only to this media segment
  #   EXT-X-BYTERANGE         - applies only to this media segment
  #   EXT-X-DISCONTINUITY ... doesn't really apply to any media segment
  #                           but could be thought of as being attached
  #                           and applying to this one.
  #
  #   EXT-X-KEY - applies to this and all subsequent media segments
  #   EXT-X-MAP - applies to this and all subsequent media segments
  class MediaSegmentSpecification < ListSpecification
    def initialize
      self.class.tag_list =
        %w( EXTINF
            EXT-X-BYTERANGE
            EXT-X-PROGRAM-DATE-TIME
            EXT-X-DISCONTINUITY
            )
      super
    end
  end
end
