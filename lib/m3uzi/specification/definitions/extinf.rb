module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13#section-3.3.2
  def define_extinf(kn = 'EXTINF')
    create_ts(kn) do | ts |
      ts.add_constraint do | tag |
        # value must be an int or float, optionally followed by a string with
        # a comma seperating them
        (pos = tag.value.to_s.index(',')) ? num = tag.value[0..pos - 1] : num = tag.value
        true if Float(num) rescue false
      end
    end
  end
end
