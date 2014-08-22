require 'm3uzi/m3u8_encryption'
require 'm3uzi/m3u8_byterange'
require 'm3uzi/types/file'

class M3U8Writer
  def initialize(pathname, m3u8_file)
    @pathname = pathname
    @m3u8_file = m3u8_file

    @encryptor = M38UEncryption.new
    @byte_range = M3U8ByteRange.new
  end

  def write_to_io(io_stream)
    @encryptor.reset
    @byte_range.reset

    write_headers(io_stream, @m3u8_file)

    # playlist_items
    @m3u8_file.items.each do |item|
      next unless item.valid?

      if item.kind_of?(M3uzi::File)
        encryption_key_line = generate_encryption_key_line(item)
        io_stream << (encryption_key_line + "\n") if encryption_key_line

        byterange_line = generate_byterange_line(item)
        io_stream << (byterange_line + "\n") if byterange_line
      end

      io_stream << (item.format + "\n")
    end

    # endlist
    io_stream << "#EXT-X-ENDLIST\n" if items(M3Uzi::File).length > 0 && (@final_media_file || @playlist_type == :vod)
  end

  def write(path)
    # TODO: Flock
    ::File.open(path, "w") { |f| write_to_io(f) }
  end

  private

  def write_headers(io_stream, m3u8_file)
    io_stream << "#EXTM3U\n"

    version = m3u8_file.version
    io_stream << "#EXT-X-VERSION:#{version}\n" if version > 1

    if m3u8_file.is_event? || m3u8_file.is_vod?
      io_stream << "#EXT-X-PLAYLIST-TYPE:#{m3u8_file.type}\n"
      # BUG??? - wheres the end - here or later?
    end

    if m3u8_file.items(File).length > 0
      io_stream << "#EXT-X-MEDIA-SEQUENCE:#{m3u8_file.initial_media_sequence + @removed_file_count}\n" if @playlist_type == :live
      max_duration = valid_items(File).map { |f| f.duration.to_f }.max || 10.0
      io_stream << "#EXT-X-TARGETDURATION:#{max_duration.ceil}\n"
    end

    # header_tags
    @header_tags.each do |item|
      io_stream << (item.format + "\n") if item.valid?
    end


  end

end

