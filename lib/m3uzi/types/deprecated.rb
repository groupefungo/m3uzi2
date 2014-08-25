module M3Uzi2

  # Generic Collection Type
  #class HashCollection
    #include Enumerable
    #def initialize
      #@members = {}
    #end

    #def [](key)
      #return @members[key]
    #end

    #def []=(key, val)
      #@members[key] =  val
    #end

    #def each(&block)
      #@members.each(&block)
    #end
  #end

end

#class M3Uzi
  #class Stream < Item
    #attr_accessor :path,
                  #:bandwidth,
                  #:program_id,
                  #:codecs,
                  #:resolution

    #@@valid_attributes = ['bandwidth', 'program_id', 'codecs', 'resolution']

    #def initialize(path = nil, attributes = nil)
      #@path = path

      #attributes.to_h.each do |k, v|
        #k = k.to_s.downcase.sub('-', '_')
        #next unless @@valid_attributes.include?(k)
        #v = $1 if v.to_s =~ /^"(.*)"$/
        #send("#{k}=", v)
      #end unless attributes.nil?
    #end

    ## Unsupported tags: EXT-X-MEDIA, EXT-X-I-FRAME-STREAM-INF
    ## Unsupported attributes of EXT-X-STREAM-INF: AUDIO, VIDEO

    #def attribute_string
      #s = []
      #s << "PROGRAM-ID=#{(program_id || 1).to_i}"
      #s << "BANDWIDTH=#{bandwidth.to_i}"
      #s << "CODECS=\"#{codecs}\"" if codecs
      #s << "RESOLUTION=#{resolution}" if resolution
      #s.join(',')
    #end

    #def format
      #"#EXT-X-STREAM-INF:#{attribute_string}\n#{path}"
    #end

    #def valid?
      #!!(path && bandwidth)
    #end
  #end
#end
#


#require 'm3uzi/m3u8_encryption'

#class M3Uzi
  #class File < Item
    #attr_accessor :path
    #attr_reader :tags

    #def initialize(path = nil)
      #@path = path
      #@tags = []
    #end

    #def attribute_string
      #"#{format_duration},#{clean_description}"
    #end

    #def format
      ## Need to add key info if appropriate?
      #"#EXTINF:#{attribute_string}\n#{path}"
    #end

    #def encryption_iv=(value)
      #@encryption_iv = M38UEncryption.check_encryption_iv(value.to_i)
    #end

    #private

    #def clean_description
      #@description.to_s.gsub(/[\r\n]/, ' ').strip
    #end

    #def format_duration
      #return format('%0.4f', d) if @duration.kind_of?(Float)
      #d.to_i.round
    #end
  #end
#end
