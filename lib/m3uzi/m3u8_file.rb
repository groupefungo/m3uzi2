require 'forwardable'

require_relative 'types/all'

require_relative 'm3u8_playlist'
require_relative 'm3u8_headers'
require_relative 'm3u8_version'

module M3Uzi2
  class M3U8File
    extend Forwardable

    attr_accessor :final_media_file

    attr_reader :headers,
                :playlist,
                :initial_media_sequence,
                :sliding_window_duration

    def_delegators :@headers,  :valid_header?
    def_delegators :@playlist, :valid_tag?

    def_delegators :@playlist, :is_vod?,
                               :is_event?,
                               :is_live?

    # is_master
    #
    # version
    #

    def initialize(spec = nil)# M3U8Version7Spec)
      @headers = M3U8Headers.new(spec)
      @playlist = M3U8Playlist.new(spec)
      @version_info = M3U8VersionInfo.new
    end

    def add_parsed_tag(tag)
      add(tag.tag, tag.attributes, tag.value)
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

    def to_s
      @headers.to_s << @playlist.to_s
    end

    def create_header(tag, attributes, value)
      M3U8Headers.create_tag(tag, attributes, value)
    end

    def create_media_segment(path)
      M3U8Playlist.create_media_segment(path)
    end

    def create_tag(tag, attributes, value)
      M3U8Playlist.create_tag(tag, attributes, value)

    end

    #def filenames
      #@playlist.items(M3Uzi::File).map { |file| file.path }
    #end

    #def streamnames
      #@playlist.items(M3Uzi::Stream).map { |stream| stream.path }
    #end

    def version
      @version_info.resolve_version(@playlist, @headers)
    end
  end
end
