class M3U8Headers
  def initialize
    @_headers = {}
  end

  def add_tag(name = nil, value = nil)
    @_headers[name] = M3Uzi::Tag.new(name, value)
  end

  def tag(key)
    tag_name = key.to_s.upcase.gsub("_", "-")
    obj = tags.detect { |tag| tag.name == tag_name }
    obj && obj.value
  end

  def tags
    @_headers
  end

  # def [](key)
  #   tag_name = key.to_s.upcase.gsub("_", "-")
  #   obj = tags.detect { |tag| tag.name == tag_name }
  #   obj && obj.value
  # end
  #
  # def []=(key, value)
  #   add_tag do |tag|
  #     tag.name = key
  #     tag.value = value
  #   end
  # end
end
