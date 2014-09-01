require 'forwardable'

require_relative 'types/attributes'
require_relative 'types/tags'
require_relative 'types/media_segment'

require_relative 'm3u8_playlist'
require_relative 'm3u8_headers'

module M3Uzi2
  # A representation/container for an M3U or M3U8 File
  class M3U8File
    extend Forwardable

    attr_reader :headers,
                :playlist,
                :type

    attr_accessor :pathname

    # def_delegators :@headers,  :valid_header?
    # def_delegators :@playlist, :valid_tag?,
    def_delegator :@playlist, :media_segments

    def initialize(pathname = nil)
      @pathname = pathname
      @headers = M3U8Headers.new
      @playlist = M3U8Playlist.new
      @type = :UNSPECIFIED
    end

    # ==== Description
    # Helper method. Creates a tag or media segment depending on the values
    # of tag_name, attributes and value. NOTE THAT THE TAG OR MEDIA SEGMENT
    # IS RETURNED BUT **IS NOT** ADDED TO THE FILE.
    def self.create_tag(tag, attributes, value)
      fail 'BOTH ATTRIBUTE AND VALUE SET'\
        "#{tag} :: #{attributes} :: #{value}" if attributes && value

      if tag.nil?
        return nil if value.strip == '' # blank line
        return create_media_segment(value)
      end

      if M3U8Playlist.valid_tag?(tag)
        return create_playlist_tag(tag, attributes, value)
      elsif M3U8Headers.valid_header?(tag)
        return create_header_tag(tag, attributes, value)
      end

      fail "UNKNOWN #{tag} :: #{attributes} :: #{value}"
    end

    # ==== Description
    # Assign the type of playlist - valid options are :MASTER, :MEDIA, or
    # :UNSPECIFIED
    def type=(val)
      @type = val.to_sym if %w(UNSPECIFIED MEDIA MASTER).include? val.to_s
    end

    # ==== Description
    # Return an array of tags matching +tag_name+
    def [](tag_name)
      @headers[tag_name].concat @playlist[tag_name]
    end

    # ==== Description
    # Add a Tag or MediaSegment.  This is a synonym for
    # +add+
    def <<(tag)
      add(tag)
    end

    # ==== Description
    # Add a Tag or MediaSegment.
    def add(tag)
      return if tag.nil?
      get_list(tag) << tag
    end

    # ==== Description
    # Helper method which both creates a tag and adds it. Tag values must
    # correspond to those for a valid Header, Playlist or MediaSegment
    def create_and_add(tag, attributes, value)
      add(self.class.create_tag(tag, attributes, value))
    end

    # ==== Description
    # return the representation of the file as a string
    def to_s
      @headers.to_s << @playlist.to_s
    end

    # ==== Description
    # Return the version of the file. If an EXT-X-VERSION tag has been added a
    # warning will be raised if the version is less than the version that is
    # required by the specification due to the use of tags from a later version
    # of the specification.
    def version
      tag_v = [@headers.map { | t | t.version }.max,
               @playlist.map { | t | t.kind_of?(Tag) ? t.version : 1 }.max
      ].max

      header_v = (v = @headers['EXT-X-VERSION'][0]) ? Integer(v.value) : tag_v

      if tag_v > header_v
        puts 'WARNING! Version mismatch. Tags indicated that the file should '\
             "have a version header with a value of #{tag_v} however the"\
             " EXT-X-VERSION header has a value of only #{header_v}"
      end

      v ? header_v : tag_v
    end

    def valid?
    end

    private

    # Note: I'm wondering if this should be public.
    # Return the list depending on the tag type or name
    def get_list(tag)
      return @playlist if tag.kind_of? MediaSegment
      return @playlist if M3U8Playlist.valid_tag?(tag.name)
      return @headers if M3U8Headers.valid_header?(tag.name)

      fail "UNKNOWN Tag :: #{tag} "
    end

    # ==== Description
    # Helper method. Creates a tag which is not added to the file.
    def self.create_header_tag(tag, attributes, value)
      return M3U8Headers.create_tag(tag, attributes, value).tap do | t |
        t.specification = M3U8Headers.specification
        t.valid?
      end
    end

    # ==== Description
    # Helper method. Creates a mediasegment which is not added to the file.
    def self.create_media_segment(path)
      return M3U8Playlist.create_media_segment(path)
    end

    # ==== Description
    # Helper method. Creates a playlist tag which is not added to the file.
    def self.create_playlist_tag(tag, attributes, value)
      return M3U8Playlist.create_tag(tag, attributes, value).tap do | t |
        t.specification = M3U8Playlist.specification
        t.valid?
      end

    end
  end
end
