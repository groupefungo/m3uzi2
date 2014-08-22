
# Parse a line from and m3u8 file and determine
class M3U8TagParser
    def self.parse(line, path, m3u8_file)
    case type(line)
    when :tag
      m3u8_file.add_tag(*parse_general_tag(line))
    when :info
      duration, description = parse_file_tag(line)
      m3u8_file.add(M3Uzi::File.new(path, duration, description))
      m3u8_file.final_media_file = false
    when :stream
      m3u8_file.add(M3Uzi::Stream.new(path, parse_stream_tag(line)))
    when :final
      m3u8_file.final_media_file = true
    end
  end

  def self.type(line)
    case line
    when /^\s*$/
      :whitespace
    when /^#(?!EXT)/
      :comment
    when /^#EXTINF/
      :info
    when /^#EXT(-X)?-STREAM-INF/
      :stream
    when /^#EXT(-X)?-ENDLIST/
      :final
    when /^#EXT(?!INF)/
      :tag
    else
      :file
    end
      end

  def self.parse_general_tag(line)
    line
      .match(/^#EXT(?:-X-)?(?!STREAM-INF)([^:\n]+)(:([^\n]+))?$/)
      .values_at(1, 3)
  end

  def self.parse_file_tag(line)
    line
      .match(/^#EXTINF:[ \t]*(\d+),?[ \t]*(.*)$/)
      .values_at(1, 2)
  end

  def self.parse_stream_tag(line)
    line
      .match(/^#EXT-X-STREAM-INF:(.*)$/)[1]
      .scan(/([A-Z-]+)\s*=\s*("[^"]*"|[^,]*)/) # return array of arrays
  end
end
