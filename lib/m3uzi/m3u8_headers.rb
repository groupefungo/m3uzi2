require 'forwardable'
require_relative 'm3u8_tag_list'
require_relative 'specification/header_specification'

module M3Uzi2
  class M3U8Headers < M3U8TagList
    def initialize
      @_spec = M3Uzi2::HeaderSpecification.new
      super()
    end

    def valid_header?(tag)
      @_spec.valid_tag?(tag)
    end

    protected

    def add(tag)
      case tag
      when M3Uzi2::Tag
        tag.specification = @_spec
        tag.valid?
        @_lines << tag
      else
        fail "Only M3Uzi2::Tags may be added to headers"
      end
    end
  end
end
