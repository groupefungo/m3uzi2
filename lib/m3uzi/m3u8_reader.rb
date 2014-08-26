require 'logger'
require_relative 'm3u8_tag_parser'
require_relative 'm3u8_file'

module M3Uzi2
  class M3U8Reader
    # ==== Description
    attr_reader :m3u8_file,
                :failure_method,
                :read_method

    # ==== Description
    #
    # ==== Params
    # +m3u8_file+ :: A M3U8File - required unless you are passing an instance
    #                to the process method...which is protected...whoops
    # +parser+ :: if no parser is provided then a M3U8TagParser will be created.
    #
    # ==== Example
    #
    # m3u8_file = M3Uzi2::M3U8File.new(pathtofile)
    # m3uzi2 = M3Uzi2::M3U8Reader.new(m3u8_file)
    # m3uzi2.read
    #
    def initialize(m3u8_file, parser = nil)
      @failure_method = :warn
      @read_method = :normal

      @m3u8_file = m3u8_file
      @parser = M3U8TagParser.new if parser.nil?
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
    def read(stream = nil)
      handle_error('No M3U8File specified', true) if @m3u8_file.nil?
      process (stream.nil? ? read_file(@m3u8_file.pathname) : read_io_stream(stream)),
              @m3u8_file

    end

    def read_file(pathname)
      unless File.exist?(pathname)
        handle_error("File #{pathname} does not exist!", true)
      end

      File.open(pathname, 'r') do |f|
        f.flock(File::LOCK_EX) if @read_method == :flock
        read_io_stream(f)
      end
    end

    def read_io_stream(stream)
      stream.readlines.map { | line | line.chomp }
    end

    protected

    # given an array of lines of an M3U8 file, validate and parse each line
    # placing the parsed result into an M3U8File.
    def process(lines, m3u8_file)
      unless valid_header?(lines[0])
        handle_error(
          "Invalid Header #{line}. File MUST begin with #EXTM3U", true)
      end

      lines.each_with_index do | line, i |
        validate_line(line, i)
        add_parsed_tag(@parser.parse(line, m3u8_file))
      end
    end

    # Basic line validation
    def validate_line(line, line_num)
      # See 3.2 : An Attribute List is a comma-separated list of
      # attribute/value pairs with no whitespace.
      check_line(line, line_num, ', ', ',', 'Commas must NOT be followed by space.')
      check_line(line, line_num, ',,', ',', 'Empty attribute ",,". (fixing)')
    end

    private

    def check_line(line, num, match, fix, error)
      if line.index(match)
        handle_error("Invalid line #{num} #{line}\r\n - #{error}. (fixing)")
        line.gsub!(match, fix)
      end
    end

    def add_parsed_tag(tag)
      handle_error("Could not parse #{tag.tag}") if tag.nil?
      @m3u8_file.add(tag.tag, tag.attributes, tag.value)
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

  m3u8_file = M3Uzi2::M3U8File.new(file)
  m3uzi2 = M3Uzi2::M3U8Reader.new(m3u8_file)
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
  puts m3u8_file['EXTINF']
  puts m3u8_file.media_segments
  m3u8_file.media_segments[0].path = "TEST" unless m3u8_file.media_segments.nil?
  puts m3u8_file.media_segments


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
