require 'logger'

require_relative 'm3u8_tag_parser'
require_relative 'm3u8_file'

module M3Uzi2
  class M3U8Reader
    attr_reader :m3u8_file,
                :failure_method,
                :read_method

    def initialize(pathname, m3u8_file)
      @pathname , @m3u8_file = pathname, m3u8_file
      @failure_method = :warn
      @read_method = :normal

      @parser = M3U8TagParser.new
    end

    # ==== Description
    # Set how the reader deals with errors. :warn logs a warning,
    # :fail will cause an error
    #
    # +val+ :: MUST be a symbol, either :warn (default) or :fail
    def failure_method=(val)
      @failure_method = val if %w(:warn :fail).include(val)
    end

    # ==== Description
    # Set the read method.
    #
    # +val+ :: MUST be either :flock or :normal. :flock will set the file
    # to be opened exclusively locked(LOCK_EX).
    def read_method=(val)
      @read_method = val if %w(:flock :normal).include(val)
    end

    # ==== Description
    # Perform the read operation on the file that was specified when
    # initializing the class. The tags will be read into the M3U8File passed
    # in the initializer.
    #
    def read(m3u8_file = nil)
      @m3u8_file = m3u8_file unless m3u8_file.nil?
      handle_error("No M3U8File specified", true) if @m3u8_file.nil?

      @lines = read_file(@pathname)

      unless valid_header?(@lines[0])
        handle_error(
          "Invalid Header #{line}. File MUST begin with #EXTM3U", true)
      end

      @lines.each { | line | add_parsed_tag(@parser.parse(line, @m3u8_file)) }
    end

    private

    def add_parsed_tag(tag)
      handle_error("Could not parse #{tag.tag}") if tag.nil?
      @m3u8_file.add(tag.tag, tag.attributes, tag.value)
    end

    def read_file(pathname)
      unless File.exist?(pathname)
        handle_error("File #{pathname} does not exist!", true)
      end
      File.open(pathname, 'r') do |f|
        f.flock(File::LOCK_EX) if @read_method == :flock
        f.readlines.collect { | line | line.chomp }
      end
    end

    # must begin with EXTINF
    def valid_header?(line)
      line == '#EXTM3U' ? true : false
    end

    def handle_error(message, force_fail = false)
      fail(message) if @failure_method == :fail || force_fail
      puts message
    end
  end
end


require_relative 'types/media_segment'
def test_reader(file)
  puts "Testing #{file}"
  m3u8_file = M3Uzi2::M3U8File.new
  m3uzi2 = M3Uzi2::M3U8Reader.new(file, m3u8_file)
  m3uzi2.read

  m3u8_file.headers.each do | tag |
    puts "#{tag.to_s}  --  #{tag.version}"
  end

  m3u8_file.playlist.each do | tag |
    if tag.kind_of? M3Uzi2::MediaSegment
      puts tag.to_s
    else
      puts "#{tag.to_s}  --  #{tag.version}"
    end
  end

  puts "*************"
  puts m3u8_file.version
  puts "*************"


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
 # $plt = M3Uzi2::PlaylistSpecification.new

  Dir['../../spec/samples/*'].each do | file |
    test_reader(file)
  end
end
