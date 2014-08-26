require 'forwardable'

require_relative 'types/attributes'
require_relative 'types/tags'
require_relative 'types/media_segment'

require_relative 'm3u8_playlist'
require_relative 'm3u8_headers'

module M3Uzi2
  class M3U8File
    extend Forwardable

    attr_reader :headers,
                :playlist

    def_delegators :@headers,  :valid_header?
    def_delegators :@playlist, :valid_tag?

    # is_master
    #
    #
    def initialize
      @headers = M3U8Headers.new
      @playlist = M3U8Playlist.new
    end

    def version
      tag_v = [@headers.map { | tag | tag.version }.max,
               @playlist.map { | tag | tag.kind_of?(Tag) ? tag.version : 1 }
                 .max
      ].max

      header_v = (v = @headers['EXT-X-VERSION'][0]) ? Integer(v.value) : tag_v

      if tag_v > header_v
        puts 'WARNING! Version mismatch. Tags indicated that the file should '\
             "have a version header with a value of #{tag_v} however the"\
             " EXT-X-VERSION header has a value of only #{header_v}"
      end

      v ? header_v : tag_v
    end

    def add(tag, attributes, value)
      fail "BOTH ATTRIBUTE AND VALUE SET: Invalid line #{line}" if attributes && value

      if tag.nil?
        return if value.strip == '' # blank line
        @playlist << create_media_segment(value)
      else
        if @playlist.valid_tag?(tag)
          @playlist << create_tag(tag, attributes, value)
        elsif @headers.valid_header?(tag)
          @headers << create_header(tag, attributes, value)
        else
          fail "Unknown #{tag} :: #{attributes} :: #{value}"
        end
      end
    end

    def add_header_tag(tag)
      @headers << tag
    end

    def to_s
      @headers.to_s << @playlist.to_s
    end

    def create_header(tag, attributes, value)
      return M3U8Headers.create_tag(tag, attributes, value)
    end

    def create_media_segment(path)
      return M3U8Playlist.create_media_segment(path)
    end

    def create_tag(tag, attributes, value)
      return M3U8Playlist.create_tag(tag, attributes, value)
    end
  end
end
