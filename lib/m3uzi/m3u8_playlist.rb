require 'm3uzi/types/item'
require 'm3uzi/types/tag'
require 'm3uzi/types/file'
require 'm3uzi/types/stream'
require 'm3uzi/types/comment'

require 'forwardable'

class M3U8Playlist
  extend Forwardable

  def initialize
    @_tags = []

    @removed_file_count = 0
    @sliding_window_duration = nil
  end

  def add(m3u8_tag)
    @_tags << m3u8_tag
    cleanup_sliding_window if m3u8_tag.kind_of?(M3Uzi::File)
  end

  def invalid(kind)
    @_tags.select { |item| item.kind_of?(kind) && item.valid? }
  end

  def valid(kind = nil)
    @_tags.select { |item| item.kind_of?(kind) && item.valid? }
  end

  def tags(kind = nil)
    kind.nil? ? @_tags : @_tags.select { |item| item.kind_of?(kind) }
  end

  def type

  end

  private

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
