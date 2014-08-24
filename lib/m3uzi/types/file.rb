

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
