require_relative "error_handler"

module M3Uzi2
  # blah
  class M3U8Writer
    include ErrorHandler
    def initialize(m3u8_file)
      @m3u8_file = m3u8_file

      @write_method = :normal
    end

    # ==== Description
    # Set the read method.
    #
    # +val+ :: MUST be either :flock or :normal. :flock will set the file
    # to be opened exclusively locked(LOCK_EX).
    def write_method=(val)
      @write_method = val if %w(:flock :normal).include(val)
    end

    def write(stream = nil)
      handle_error('No M3U8File specified', true) if @m3u8_file.nil?
      stream.nil? ? write_file(@m3u8_file.pathname) : write_io_stream(stream)
    end

    def write_file(pathname)
      File.open(pathname, 'w') do | f |
        f.flock(File::LOCK_EX) if @write_method == :flock
        write_io_stream(f)
      end
    end

    def write_io_stream(stream)
      write_header(stream, @m3u8_file.headers)
      write_playlist(stream, @m3u8_file.headers)
    end

    private

    def write_playlist(io_stream, playlist)
      playlist.each do | item |
        io_stream << item << '\n'
      end
    end

    def write_header(io_stream, headers)
      headers.each do | item |
        io_stream << item << '\n'
      end
    end
  end
end
