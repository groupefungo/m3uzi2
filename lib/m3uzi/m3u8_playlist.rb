require_relative 'm3u8_tag_list'
require_relative 'specification/playlist_specification'

module M3Uzi2
  # 1) We want to preserve the order of entries (hash does this)
  # 2) Keys may be duplicated - can use compare_by_identity
  class M3U8Playlist < M3U8TagList

    def initialize
      super()
    end

    def self.specification
      self._specification ||= PlaylistSpecification.new
    end

    def self.valid_tag?(tag)
      self.specification.valid_tag?(tag)
    end

    def self.create_media_segment(path)
      MediaSegment.new(path)
    end

    protected

    def add(tag)
      if super(tag).nil?
        return @_lines << tag if tag.kind_of? MediaSegment
        fail "Only M3Uzi2::Tags or MediaSegments may be added to playlist"
      end
    end
  end



  # Note: unused but will revive
  #class M3U8SlidingWindow
    #def initialize
      #@removed_file_count = 0
      #@sliding_window_duration = nil
    #end


    #def cleanup_sliding_window
      #return unless @sliding_window_duration && @type == :live
      #while total_duration > @sliding_window_duration
        #first_file = @_items.find do |item|
          #item.kind_of?(M3Uzi::File) && item.valid?
        #end
        #@_items.delete(first_file)
        #@removed_file_count += 1
      #end
    #end

    #def total_duration
      #valid(M3Uzi::File).reduce(0.0) { |a, e| a + e.duration.to_f }
    #end
  #end

end
