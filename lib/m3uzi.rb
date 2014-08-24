$LOAD_PATH << File.dirname(__FILE__)

require 'forwardable'

require 'm3uzi/version'
require 'm3uzi/m3u8_reader'
require 'm3uzi/m3u8_writer'
require 'm3uzi/m3u8_file'

# A client to support parsing of M3U and M3U8 files, based on zencoder/m3uzi,
# with extensive refactorization.
#
# Updated to support the latest draft RFC specification:
#   http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
module M3Uzi2
  class M3Uzi
    extend Forwardable

  #  def_delegators :@m3u8_reader, :read
  #  def_delegators :@m3u8_writer, :write

    def_delegators :@m3u8_file, :headers,
                                :playlist,
                                :is_valid?
    def initialize(pathname)
      @m3u8_file   = M3U8File.new
      @m3u8_reader = M3U8Reader.new(pathname, @m3u8_file)
#      @m3u8_writer = M3U8Writer.new(pathname, @m3u8_file)
    end

    def load
      @m3u8_reader.read
    end

    def save
      @m3u8_writer.write
    end
  end
end


def test_m3u8(file)
  puts "Testing #{file}"
  m3uzi2 = M3Uzi2::M3Uzi.new(file)
  m3uzi2.load
  #m3uzi2.playlist.items.each do | f |
    #puts "Invalid Tag #{f.inspect}" unless f.valid?
  #end
  #return m3uzi.is_valid?
rescue Exception => e
  puts "#{file} FAILED .."
  puts e.message
  return false
end

if $PROGRAM_NAME == __FILE__
  Dir['../spec/samples/*'].each do | file |
    test_m3u8(file)
  end
end
