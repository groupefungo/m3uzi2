module M3Uzi2
  # Tags parsed as of version 7 (RFC revision 13)
  #
  # As versions 6 plus:
  #
  # EXT-X-SESSION-DATA:<attribute list>

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
    # Abstraction for a line of a file that has been parsed into tag,
    # attribute, value.
    class ParsedTag
      attr_reader :tag,
                  :attributes,
                  :value

      def initialize(tag = nil, attributes = nil, value = nil)
        @tag, @attributes, @value = tag, attributes, value
      end
    end

    INDEPENDENT_TAGS = %w( #EXTM3U
                           #EXT-X-ENDLIST
                           #EXT-X-DISCONTINUITY
                           #EXT-X-I-FRAMES-ONLY
                           #EXT-X-INDEPENDENT-SEGMENTS )

    VALUE_TAGS       = %w( #EXTINF
                           #EXT-X-BYTERANGE
                           #EXT-X-TARGETDURATION
                           #EXT-X-MEDIA-SEQUENCE
                           #EXT-X-PROGRAM-DATE-TIME
                           #EXT-X-ALLOW-CACHE
                           #EXT-X-PLAYLIST-TYPE
                           #EXT-X-DISCONTINUITY-SEQUENCE
                           #EXT-X-VERSION )

    ATTRIBUTE_TAGS   = %w( #EXT-X-KEY
                           #EXT-X-MEDIA
                           #EXT-X-STREAM-INF
                           #EXT-X-MAP
                           #EXT-X-I-FRAME-STREAM-INF
                           #EXT-X-START
                           #EXT-X-SESSION-DATA )

    def parse(line, _m3u8_file)
      return nil unless valid?(line)
      return nil if (value = parse_line(line)).nil?
      ParsedTag.new(*value)
    end

    # on return only attributes OR value should be set, never both
    def parse_line(line)
      # it isn't a tag if it doesnt begin with #
      return [nil, nil, line] unless line[0] == '#'

      # is it an idependent tag?
      return [line[1..-1], nil, nil] if independent_tag?(line)
      return nil unless (pos = line.index(':'))

      # is it a VALUE tag?
      tag, attr_or_val = [line[1..pos - 1], line[pos + 1..-1]]
      return [tag, nil, attr_or_val] if value_tag?(line[0..pos - 1])

      # it *should* be an attribute tag.
      return [tag, attr_or_val, nil] if attribute_tag?(line[0..pos - 1])

      # I don't know wtf it is!
      nil
    end

    def independent_tag?(tag)
      return INDEPENDENT_TAGS.include?(tag)
    end

    def value_tag?(tag)
      return VALUE_TAGS.include?(tag)
    end

    def attribute_tag?(tag)
      return ATTRIBUTE_TAGS.include?(tag)
    end

    # TODO
    # Test if a line is valid which means no whitespace seperating tags
    def valid?(line)
      true
    end
  end
end
