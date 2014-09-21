require 'forwardable'

require_relative 'm3uzi/m3u8_reader'
require_relative 'm3uzi/m3u8_writer'
require_relative 'm3uzi/m3u8_file'

# A client to support M3U and M3U8 files, based on zencoder/m3uzi,
# with extensive refactorization.
#
# Updated to support the latest draft RFC specification:
#   http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
#
module M3Uzi2
  class M3Uzi2
    extend Forwardable

    def_delegators :@m3u8_file, :headers, :playlist, :media_segments,
                                :pathname, :type, :[], :<<, :add,
                                :create_and_add, :to_s, :version,
                                :valid?, :dump, :final_media_segment?,
                                :slide!

    def_delegators :@m3u8_reader, :read_method, :read_method=, :read,
                                  :read_file, :read_io_stream

    def_delegators :@m3u8_writer, :write_method, :write_method=, :write,
                                  :write_file, :write_io_stream

    def initialize(pathname)
      @m3u8_file   = M3U8File.new(pathname)
      @m3u8_reader = M3U8Reader.new(@m3u8_file)
      @m3u8_writer = M3U8Writer.new(@m3u8_file)
    end

    def load
      @m3u8_reader.read
    end

    def save(pathname = nil)
      pathname.nil? ?  @m3u8_writer.write : @m3u8_writer.write_file(pathname)
    end
  end
end

if $PROGRAM_NAME == __FILE__
  m3u = M3Uzi2::M3Uzi2.new('../spec/samples/2014-08-18-122730.M3U8')
  m3u.load
  puts m3u.valid?
  m3u.save('../spec/samples/2014-08-18-122730.COPY.M3U8')
end
