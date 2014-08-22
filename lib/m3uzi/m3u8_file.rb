require 'forwardable'

require 'm3uzi/types/item'
require 'm3uzi/types/tag'
require 'm3uzi/types/file'
require 'm3uzi/types/stream'
require 'm3uzi/types/comment'

require 'm3uzi/m3u8_playlist'
require 'm3uzi/m3u8_headers'
require 'm3uzi/m3u8_version'

class M3U8File
  extend Forwardable

  attr_accessor :final_media_file
  attr_reader :headers,
              :playlist,
              :initial_media_sequence,
              :sliding_window_duration

  def_delegators :@headers,  :add_tag
  def_delegators :@playlist, :add
  def_delegators :@playlist, :is_vod?,
                             :is_event?,
                             :is_live?
  def initialize
    @headers = M3U8Headers.new
    @playlist = M3U8Playlist.new
    @version_info = M3U8VersionInfo.new

    @final_media_file = false

    # It looks like this should be set on reading in the file but isn't
    # ...
    @initial_media_sequence = 0
  end

  def filenames
    @playlist.items(M3Uzi::File).map { |file| file.path }
  end

  def streamnames
    @playlist.items(M3Uzi::Stream).map { |stream| stream.path }
  end

  def version
    @version_info.resolve_version(@playlist, @headers)
  end
end
