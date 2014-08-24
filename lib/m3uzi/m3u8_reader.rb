require_relative 'm3u8_tag_parser'
require_relative 'm3u8_file'

require_relative 'specification/playlist_specification'
require_relative 'specification/header_specification'

module M3Uzi2
  class M3U8Reader
    attr_reader :m3u8_file

    def initialize(pathname, m3u8_file)
      @pathname = pathname
      @m3u8_file = m3u8_file
      @warn_or_fail = :warn
    end

    def read(m3u8_file = nil)
      @parser = M3Uzi2::M3U8TagParser.new
      @m3u8_file = m3u8_file unless m3u8_file.nil?

      @lines = read_file(@pathname)
      valid_header?(@lines[0])

      @lines.each do | line |
        parsed_tag = @parser.parse(line, @m3u8_file)
        fail "Could not parse #{line}" if parsed_tag.nil?
        @m3u8_file.add_parsed_tag(parsed_tag)
      end
    end

    private

    def read_file(pathname, flock = false)
      File.open(pathname, 'r') do |f|
        f.flock(File::LOCK_EX)
        f.readlines.collect{ | line | line.chomp }
      end
    end

    # must begin with EXTINF
    def valid_header?(line)
      if line != '#EXTM3U'
        fail "Invalid Header #{line}. File MUST begin with #EXTM3U"
      end
    end
  end
end

def test_reader(file)

  puts "Testing #{file}"
  m3u8_file = M3Uzi2::M3U8File.new
  m3uzi2 = M3Uzi2::M3U8Reader.new(file, m3u8_file)
  m3uzi2.read
#  puts m3u8_file.to_s

  #m3uzi2.playlist.items.each do | f |
    #puts "Invalid Tag #{f.inspect}" unless f.valid?
  #end
  #return m3uzi.is_valid?
#rescue Exception => e
  #puts "#{file} FAILED .."
  #puts e#.message
  #return false
end

if $PROGRAM_NAME == __FILE__
  $plt = M3Uzi2::PlaylistSpecification.new

  Dir['../../spec/samples/*'].each do | file |
    test_reader(file)
  end
end
