require 'forwardable'

require_relative 'types/attributes'
require_relative 'types/tags'
require_relative 'types/media_segment'

require_relative 'm3u8_playlist'
require_relative 'm3u8_headers'
require_relative 'error_handler'

module M3Uzi2
  # A representation/container for an M3U or M3U8 File
  class M3U8File
    include ErrorHandler
    extend Forwardable

    attr_reader :headers,
                :playlist,
                :type

    attr_accessor :pathname

    def_delegator :@playlist, :media_segments,
                              :final_media_segment?

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
      handle_error 'BOTH ATTRIBUTE AND VALUE SET'\
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

      handle_error "UNKNOWN #{tag} :: #{attributes} :: #{value}"
      nil
    end

    def type(nil_on_mismatch: false)
      unless PlaylistCompatability.check(@headers, @playlist)
        handle_error 'File Mixes Incompatable Playlist Tag Types'
        return nil if nil_on_mismatch
      end

      @type
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
      @headers[tag_name].concat(@playlist[tag_name])
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
      return nil if tag.nil?
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
    def version(nil_on_mismatch: false, return_tag_version: false)
      tag_v = [@headers.map { | t | t.version }.max || 1 ,
               @playlist.map { | t | t.kind_of?(Tag) ? t.version : 1 }.max || 1
      ].max

      specified_v = @headers['EXT-X-VERSION'][0]
      header_v = specified_v ? Integer(specified_v.value) : tag_v

      if tag_v > header_v
        handle_error 'WARNING! Version mismatch. Tags indicated that the file'\
             " should have a version header with a value of #{tag_v},however "\
             "the EXT-X-VERSION header has a value of only #{header_v}"
        return nil if nil_on_mismatch
      end

      return tag_v if return_tag_version

      specified_v ? header_v : tag_v
    end

    def valid?
      @headers.all? { | h | h.valid? } &&
        @playlist.all? { | p | p.valid? } &&
        version(true) &&
        PlaylistCompatability.check(@headers, @playlist)
    end

    def dump
      @headers.each { | h | dump_tag(h) }
      @playlist.each { | h | dump_tag(h) }
    end

    private

    def dump_tag(tag)
      puts "#{tag.class} -- comp: #{tag.playlist_compatability} "\
           "version:#{tag.version} -- valid?#{tag.valid?} :: #{tag}"
    end

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
