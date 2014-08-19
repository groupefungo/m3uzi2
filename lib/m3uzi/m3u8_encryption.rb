
class M38UEncryption
  def initialize
    reset_encryption_key_history
  end

  def reset_encryption_key_history
    @encryption_key_url = nil
    @encryption_iv = nil
    @encryption_sequence = 0
  end

  def generate_encryption_key_line(file)
    generate_line = false

    default_iv = @encryption_iv || format_iv(@encryption_sequence)

    if (file.encryption_key_url != :unset) && (file.encryption_key_url != @encryption_key_url)
      @encryption_key_url = file.encryption_key_url
      generate_line = true
    end

    if @encryption_key_url && file.encryption_iv != @encryption_iv
      @encryption_iv = file.encryption_iv
      generate_line = true
    end

    @encryption_sequence += 1

    if generate_line
      if @encryption_key_url.nil?
        "#EXT-X-KEY:METHOD=NONE"
      else
        attrs = ['METHOD=AES-128']
        attrs << 'URI="' + @encryption_key_url.gsub('"','%22').gsub(/[\r\n]/,'').strip + '"'
        attrs << "IV=#{@encryption_iv}" if @encryption_iv
        '#EXT-X-KEY:' + attrs.join(',')
      end
    else
      nil
    end
  end
end
