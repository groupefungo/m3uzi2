require 'forwardable'
require_relative 'm3u8_tag_list'
require_relative 'specification/playlist_specification'

module M3Uzi2
  # 1) We want to preserve the order of entries (hash does this)
  # 2) Keys may be duplicated - can use compare_by_identity
  class M3U8Playlist < M3U8TagList
    extend Forwardable

    def_delegators :@_spec, :valid_tag?

    def initialize(spec_version = 7)
      @_spec = PlaylistSpecification.new
      super()
    end

    def add(tag)
      tag.valid?
      case tag
      when Tag
        @_lines << tag
      when MediaSegment
        @_lines << tag
      else
        fail "Only M3Uzi2::Tags or MediaSegments may be added to playlist"
      end
    end

    def self.create_media_segment(path)
      MediaSegment.new(path)
    end

  end

  class M3U8SlidingWindow
    def initialize
      @removed_file_count = 0
      @sliding_window_duration = nil
    end


    def cleanup_sliding_window
      return unless @sliding_window_duration && @type == :live
      while total_duration > @sliding_window_duration
        first_file = @_items.find do |item|
          item.kind_of?(M3Uzi::File) && item.valid?
        end
        @_items.delete(first_file)
        @removed_file_count += 1
      end
    end

    def total_duration
      valid(M3Uzi::File).reduce(0.0) { |a, e| a + e.duration.to_f }
    end
  end

end
