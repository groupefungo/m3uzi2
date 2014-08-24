require_relative 'tag_definition'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # #section-3.4.8
  class EXT_X_INDEPENDENT_SEGMENTS < IndependentTag
    def initialize(tags, tn = 'EXT-X-INDEPENDENT_SEGMENTS')
      super(tags, tn)
    end

    def define_constraints(ts)
      #valid_instance_constraint(ts, 0..INFINITY)
    end
  end
end
