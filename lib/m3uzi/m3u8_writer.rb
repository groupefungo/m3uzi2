
class M3U8Writer
  def initialize(pathname, m3u8_file)
    @pathname = pathname
    @m3u8_file = m3u8_file
  end

  def write_to_io(io_stream)
    reset_encryption_key_history
    reset_byterange_history

    check_version_restrictions
    io_stream << "#EXTM3U\n"
    io_stream << "#EXT-X-VERSION:#{@version.to_i}\n" if @version > 1
    io_stream << "#EXT-X-PLAYLIST-TYPE:#{@playlist_type.to_s.upcase}\n" if [:event,:vod].include?(@playlist_type)

    if items(File).length > 0
      io_stream << "#EXT-X-MEDIA-SEQUENCE:#{@initial_media_sequence+@removed_file_count}\n" if @playlist_type == :live
      max_duration = valid_items(File).map { |f| f.duration.to_f }.max || 10.0
      io_stream << "#EXT-X-TARGETDURATION:#{max_duration.ceil}\n"
    end

    @header_tags.each do |item|
      io_stream << (item.format + "\n") if item.valid?
    end

    @playlist_items.each do |item|
      next unless item.valid?

      if item.kind_of?(File)
        encryption_key_line = generate_encryption_key_line(item)
        io_stream << (encryption_key_line + "\n") if encryption_key_line

        byterange_line = generate_byterange_line(item)
        io_stream << (byterange_line + "\n") if byterange_line
      end

      io_stream << (item.format + "\n")
    end

    io_stream << "#EXT-X-ENDLIST\n" if items(File).length > 0 && (@final_media_file || @playlist_type == :vod)
  end

  def write(path)
    ::File.open(path, "w") { |f| write_to_io(f) }
  end


end

