require_relative 'tag_definition'
require 'uri'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # section-3.4.9

  class EXT_X_I_FRAME_STREAM_INF < AttributeTag
    def initialize(tags, tn = 'EXT-X-I-FRAME-STREAM-INF')
      super(tags, tn)
    end

    def define_attributes(ts)
      ts.create_attributes(%w(BANDWIDTH URI CODECS RESOLUTION VIDEO))
    end

    def define_constraints(ts)
    end

    def define_attribute_constraints(ts)
    end

  end
end
