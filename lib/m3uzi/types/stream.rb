class M3Uzi
  class Stream < Item
    attr_accessor :path,
                  :bandwidth,
                  :program_id,
                  :codecs,
                  :resolution

    @@valid_attributes = ['bandwidth', 'program_id', 'codecs', 'resolution']

    def initialize(path = nil, attributes = nil)
      @path = path

      attributes.to_h.each do |k, v|
        k = k.to_s.downcase.sub('-', '_')
        next unless @@valid_attributes.include?(k)
        v = $1 if v.to_s =~ /^"(.*)"$/
        send("#{k}=", v)
      end unless attributes.nil?
    end

    # Unsupported tags: EXT-X-MEDIA, EXT-X-I-FRAME-STREAM-INF
    # Unsupported attributes of EXT-X-STREAM-INF: AUDIO, VIDEO

    def attribute_string
      s = []
      s << "PROGRAM-ID=#{(program_id || 1).to_i}"
      s << "BANDWIDTH=#{bandwidth.to_i}"
      s << "CODECS=\"#{codecs}\"" if codecs
      s << "RESOLUTION=#{resolution}" if resolution
      s.join(',')
    end

    def format
      "#EXT-X-STREAM-INF:#{attribute_string}\n#{path}"
    end

    def valid?
      !!(path && bandwidth)
    end
  end
end
