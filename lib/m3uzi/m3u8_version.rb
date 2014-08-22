

require 'm3uzi/types/item'
require 'm3uzi/types/tag'
require 'm3uzi/types/file'
require 'm3uzi/types/stream'
require 'm3uzi/types/comment'
# Determine the version of an m3u or m3u8 file
class M3U8VersionInfo
  attr_reader :version

  # Allow forcing of a version to a specific number
  def initialize(ver = 1)
    @version = ver
  end

  # Attempt to determine the version from the contents of the M3U8 File
  def check_version(playlist, headers)
    @version = 2 if version2?(playlist)
    @version = 3 if version3?(playlist)
    @version = 4 if version4?(playlist, headers)
    @version = 5 if version5?(playlist, headers)
    @version = 6 if version6?(playlist, headers)
    @version = 7 if version7?(playlist, headers)

    # NOTES
    #   EXT-X-I-FRAME-STREAM-INF is supposed to be ignored by older clients.
    #   AUDIO/VIDEO attributes of X-STREAM-INF are used in conjunction with
    #   MEDIA, so it should trigger v4.

    @version
  end

  private

  def version2?(playlist)
    return true if playlist.valid_items(M3Uzi::File).find do |item|
      item.encryption_key_url && item.encryption_iv
    end
  end

  def version3?(playlist)
    return true if playlist.valid_items(M3Uzi::File).find do |item|
      item.duration.kind_of?(Float)
    end
  end

  def version4?(playlist, _headers)
    return true if playlist.valid_items(M3Uzi::File).find do |item|
      item.byterange
    end

    # NB: Check, this looks bugged since Tags went in the headers.
    return true if playlist.valid_items(M3Uzi::Tag).find do |item|
      %w('MEDIA','I-FRAMES-ONLY').include?(item.name)
    end
  end
end
