require 'forwardable'
require_relative 'm3u8_tag_list'
require_relative 'specification/header_specification'

module M3Uzi2
  class M3U8Headers < M3U8TagList
    extend Forwardable

    def initialize(spec_version = 7)
      @_spec = M3Uzi2::HeaderSpecification.new
      super()
    end

    def add(tag)
      tag.valid?
      case tag
      when M3Uzi2::Tag
        @_lines << tag
      else
        fail "Only M3Uzi2::Tags may be added to headers"
      end
    end

    def valid_header?(tag)
      @_spec.valid_tag?(tag)
    end

  end
end
