
# NB: The encryption methods were extracted from m3uzi but as far as I can
# tell, they have ZERO actual effect.
#
# A useful writeup on the IVs and some quick fire methods of encrypting media
# for use in streaming can be forund at:
# ttp://www.opensolutions.ie/blog/2010/08/http-streaming-with-encryption-under-linux/

class M3U8EncryptionOptions
  attr_accessor :method,
                :uri,
                :iv,
                :keyformatversions
  def initialize(method, uri, iv = nil, keyformatversions = nil)
    @method = method
    @uri = uri
    @iv = iv
    @keyformatversions = keyformatversions
  end
end

class M38UEncryption
  class << self
    # Given a url and iv generate the tag line
    def generate_tag(url = nil, encryption_iv = nil)
      return '#EXT-X-KEY:METHOD=NONE' if url.nil?

      attrs = ['METHOD=AES-128']
      attrs << "URI=\"#{clean_url(url)}\""
      attrs << "IV=#{encryption_iv}" unless encryption_iv.nil?
      '#EXT-X-KEY:' + attrs.join(',')
    end

    def generate_key(file)
      [file.encryption_key_url, file.encryption_iv]
    end

    # NB: iv stands for Initialization Vector
    def check_encryption_iv(value)
      value = $' if value.to_s =~ /^0x/i

      if value.kind_of?(String)
        fail 'Invalid encryption_iv given' unless value.length <= 32 && value =~ /^[0-9a-f]+$/i
        value = '0x' + value.downcase.rjust(32, '0')
      else
        value = format_iv(value.to_i)
      end
      value
    end

    def format_iv(num)
      '0x' + num.to_s(16).rjust(32, '0')
    end

    #def format_iv(num)
      #self.class.format_iv(num)
    #end

    def clean_url(url)
      return "" if url.nil?
      url
        .gsub('"', '%22')
        .gsub(/[\r\n]/, '')
        .strip
    end
  end
end
