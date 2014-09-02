
# A useful writeup on the IVs and some quick fire methods of encrypting media
# for use in streaming can be found at:
#
# http://www.opensolutions.ie/blog/2010/08/http-streaming-with-encryption-under-linux/

class M38UIV
  class << self
    # NB: iv stands for Initialization Vector
    def check_iv(value)
      Integer(value) && value.to_s[0..1] == '0x'
    rescue
      false
    end

    def iv(num)
      '0x' << num.to_s(16).rjust(32, '0')
    end
  end
end
