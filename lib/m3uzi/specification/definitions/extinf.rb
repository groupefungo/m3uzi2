require_relative 'tag_definition'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # #section-3.3.2
  class EXTINF < TagDefinition
    def initialize(tags, tn = 'EXTINF')
      super(tags, tn)
    end

    def define_constraints(ts)
      ts.add_constraint('Invalid Value') do | tag |
        num = tag.value
        (pos = tag.value.to_s.index(',')) ? num = tag.value[0..pos - 1] : nil
        true if Float(num) rescue false
      end
    end
  end
end
