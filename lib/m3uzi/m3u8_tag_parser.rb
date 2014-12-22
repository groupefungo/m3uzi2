module M3Uzi2
  # Abstraction for a line of a file that has been parsed into tag,
  # attribute, value.
  class M3U8ParsedTag
    attr_reader :tag,
                :attributes,
                :value
    def initialize(tag = nil, attributes = nil, value = nil)
      @tag, @attributes, @value = tag, attributes, value
    end
  end

  # Tags parsed as of version 7 (RFC revision 13)
  # EXT-X-SESSION-DATA

  # Tags parsed as of version 6 (RFC revision 13)
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  #
  #  EXTM3U
  #  EXTINF:<duration>,<title>
  #  EXT-X-BYTERANGE:<n>[@<o>]
  #  EXT-X-TARGETDURATION:<s>
  #  EXT-X-MEDIA-SEQUENCE:<number>
  #  EXT-X-KEY:<attribute-list>
  #  EXT-X-PROGRAM-DATE-TIME:<YYYY-MM-DDThh:mm:ssZ>
  #  EXT-X-ALLOW-CACHE:<YES|NO>
  #  EXT-X-PLAYLIST-TYPE:<EVENT|VOD>
  #  EXT-X-ENDLIST
  #  EXT-X-MEDIA:<attribute-list>
  #  EXT-X-STREAM-INF:<attribute-list>
  #    <URI>
  #  EXT-X-DISCONTINUITY
  #  EXT-X-DISCONTINUITY-SEQUENCE:<number>
  #  EXT-X-I-FRAMES-ONLY
  #  EXT-X-MAP:<attribute-list>
  #  EXT-X-I-FRAME-STREAM-INF:<attribute-list>
  #  EXT-X-INDEPENDENT-SEGMENTS
  #  EXT-X-START:<attribute list>
  #  EXT-X-VERSION:<n>

  # Note that the parser is primarily used by the reader
  class M3U8TagParser
    def parse(line, _m3u8_file)
      parse_line(line)
    end

    # on return only attributes OR value should be set, never both
    def parse_line(line)
      return nil unless valid?(line)

      # it isn't a tag if it doesnt begin with #
      return M3U8ParsedTag.new(nil, nil, line) unless line[0] == '#'

      # is it an idependent tag?
      return M3U8ParsedTag.new(line[1..-1]) if independent_tag?(line)
      return nil unless (pos = line.index(':'))

      # is it a VALUE tag?
      tag, attr_or_val = [line[1..pos - 1], line[pos + 1..-1]]
      return M3U8ParsedTag.new(tag, nil, attr_or_val) if value_tag?(line[0..pos - 1])
      return M3U8ParsedTag.new(tag, attr_or_val) if attribute_tag?(line[0..pos - 1])

      # I don't know wtf it is!
      nil
    end

    private

    def independent_tag?(tag)
      tags = %w( #EXTM3U #EXT-X-ENDLIST #EXT-X-DISCONTINUITY
                 #EXT-X-I-FRAMES-ONLY #EXT-X-INDEPENDENT-SEGMENTS )
      return tags.include?(tag)
    end

    def value_tag?(tag)
      tags = %w( #EXTINF #EXT-X-BYTERANGE #EXT-X-TARGETDURATION
                 #EXT-X-MEDIA-SEQUENCE #EXT-X-PROGRAM-DATE-TIME
                 #EXT-X-ALLOW-CACHE #EXT-X-PLAYLIST-TYPE
                 #EXT-X-DISCONTINUITY-SEQUENCE #EXT-X-VERSION )
      return tags.include?(tag)
    end

    def attribute_tag?(tag)
      tags = %w( #EXT-X-KEY #EXT-X-MEDIA #EXT-X-STREAM-INF #EXT-X-MAP
                 #EXT-X-I-FRAME-STREAM-INF #EXT-X-START #EXT-X-SESSION-DATA )
      return tags.include?(tag)
    end

    # Test if a line is valid which means no whitespace seperating tags
    #
    def valid?(line)
      true
    end
  end
end
