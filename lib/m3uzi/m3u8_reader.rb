require_relative 'm3u8_tag_parser'
require_relative 'm3u8_file'

class M3U8Reader
  attr_reader :m3u8_file

  def initialize(pathname, m3u8_file)
    @pathname = pathname
    @m3u8_file = m3u8_file
  end

  def read(m3u8_file = nil)
    @m3u8_file = m3u8_file unless m3u8_file.nil?

    lines = readfile(@pathname)

    lines.each_with_index do |line, i|
      path = lines[i + 1].strip unless lines[i + 1].nil?
      M3U8TagParser.parse(line, path, @m3u8_file)
    end
  end

  private

  def readfile(pathname)
    File.readlines(@pathname)
    #lines = []
    #File.open(pathname, 'r') do |f|
      #f.flock(File::LOCK_EX)
      #lines = f.readlines(@pathname)
    #end

    #lines
  end
end

