$LOAD_PATH << File.dirname(__FILE__)

require 'forwardable'

require 'm3uzi/version'
require 'm3uzi/m3u8_reader'
require 'm3uzi/m3u8_writer'
require 'm3uzi/m3u8_file'

class M3Uzi2
  extend Forwardable

#  def_delegators :@m3u8_reader, :read
#  def_delegators :@m3u8_writer, :write

  def_delegators :@m3u8_file, :headers,
                              :playlist


  def initialize(pathname)
    @m3u8_file   = M3U8File.new
    @m3u8_reader = M3U8Reader.new(pathname, @m3u8_file)
    @m3u8_writer = M3U8Writer.new(pathname, @m3u8_file)
  end

  def load
    @m3u8_reader.read
  end

  def save

  end

  protected

  def self.format_iv(num)
    '0x' + num.to_s(16).rjust(32,'0')
  end

  def format_iv(num)
    self.class.format_iv(num)
  end
end

if $PROGRAM_NAME == __FILE__
  #m3uzi2 = M3Uzi2.new('../spec/samples/2014-08-18-122730.M3U8')
  #m3uzi2 = M3Uzi2.new('../spec/samples/index.m3u8')
  m3uzi2 = M3Uzi2.new('../spec/samples/stream.m3u8')
  m3uzi2.load
  m3uzi2.playlist.items.each do | f |
    puts f.inspect
end
end


