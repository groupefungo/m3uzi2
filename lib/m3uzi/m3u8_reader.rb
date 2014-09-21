require_relative 'm3u8_tag_parser'
require_relative 'm3u8_file'
require_relative 'error_handler'

module M3Uzi2
  # Reader an M3U8 file, parsing each line and placing the resulting tag
  # into an M3U8File
  class M3U8Reader
    include ErrorHandler

    # ==== Description
    attr_reader :m3u8_file,
                :read_method

    # ==== Description
    #
    # ==== Params
    # +m3u8_file+ :: A M3U8File - required unless you are passing an instance
    #                to the process method...which is protected...whoops
    # +parser+ :: if no parser is provided a M3U8TagParser will be created.
    #
    # ==== Example
    #
    # m3u8_file = M3Uzi2::M3U8File.new(pathtofile)
    # m3uzi2 = M3Uzi2::M3U8Reader.new(m3u8_file)
    # m3uzi2.read
    #
    def initialize(m3u8_file, parser = nil)
      @read_method = :normal

      @m3u8_file = m3u8_file
      @parser = M3U8TagParser.new if parser.nil?
    end

    # ==== Description
    # Set the read method.
    #
    # +val+ :: MUST be either :flock or :normal. :flock will set the file
    # to be opened exclusively locked(LOCK_EX).
    def read_method=(val)
      @read_method = val if %w(:flock :normal).include?(val)
    end

    # ==== Description
    def read_file(pathname)
      handle_error('No M3U8File specified', true) if @m3u8_file.nil?
      unless File.exist?(pathname)
        handle_error("File #{pathname} does not exist!", true)
      end

      File.open(pathname, 'r') do |f|
        f.flock(File::LOCK_EX) if @read_method == :flock
        read_io_stream(f)
      end
    end

    # ==== Description
    def read_io_stream(stream)
      stream.readlines.map { | line | line.chomp }
    end

    # ==== Description
    # Perform the read operation on the file that was specified when
    # initializing the class. The tags will be read into the M3U8File passed
    # in the initializer.
    def read(stream = nil)
      if stream.nil?
        lines = read_file(@m3u8_file.pathname)
      else
        lines = read_io_stream(stream)
      end

      process(lines, @m3u8_file)
    end

    protected

    # given an array of lines of an M3U8 file, validate and parse each line
    # placing the parsed result into an M3U8File.
    def process(lines, m3u8_file)
      unless valid_header?(lines[0])
        handle_error(
          "Invalid Header #{lines[0]}. File MUST begin with #EXTM3U", true)
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
      check_line(line, line_num, ', ', ',',
                 'Commas must NOT be followed by space')
      check_line(line, line_num, ',,', ',', 'Empty attribute ",,"')
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
      @m3u8_file.create_and_add(tag.tag, tag.attributes, tag.value)
    end

    # must begin with EXTINF
    def valid_header?(line)
      line == '#EXTM3U' ? true : false
    end
  end
end
