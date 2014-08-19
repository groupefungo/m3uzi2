class M3U8ByteRange
  def initialize
    @prev_byterange_endpoint = nil
  end

  def reset_byterange_history
    @prev_byterange_endpoint = nil
  end

  def generate_byterange_line(file)
    line = nil

    if file.byterange
      if file.byterange_offset && file.byterange_offset != @prev_byterange_endpoint
        offset = file.byterange_offset
      elsif @prev_byterange_endpoint.nil?
        offset = 0
      else
        offset = nil
      end

      line = "#EXT-X-BYTERANGE:#{file.byterange_offset.to_i}"
      line += "@#{offset}" if offset

      @prev_byterange_endpoint = offset + file.byterange
    else
      @prev_byterange_endpoint = nil
    end

    line
  end
end

