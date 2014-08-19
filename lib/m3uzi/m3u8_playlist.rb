require 'm3uzi/types/item'
require 'm3uzi/types/tag'
require 'm3uzi/types/file'
require 'm3uzi/types/stream'
require 'm3uzi/types/comment'

class M3U8Playlist
  attr_accessor :type

  def initialize
    @type = :live
    @_items = []

    @removed_file_count = 0
    @sliding_window_duration = nil
  end

  def add(m3u8_item)
    @_items << m3u8_item
    cleanup_sliding_window if m3u8_item.kind_of?(M3Uzi::File)
  end

  # def add_comment(comment = nil)
    # new_comment = M3Uzi::Comment.new(comment)
    # @_items << new_comment
  # end

  def valid_items(kind)
    @_items.select { |item| item.kind_of?(kind) && item.valid? }
  end

  def items(kind = nil)
    kind.nil? ? @_items : @_items.select { |item| item.kind_of?(kind) }
  end

  private

  def cleanup_sliding_window
    return unless @sliding_window_duration && @type == :live
    while total_duration > @sliding_window_duration
      first_file = @_items.find do |item|
        item.kind_of?(File) && item.valid?
      end
      @_items.delete(first_file)
      @removed_file_count += 1
    end
  end

  def total_duration
    valid_items(File).reduce(0.0) { |a, e| a + e.duration.to_f }
  end
end
