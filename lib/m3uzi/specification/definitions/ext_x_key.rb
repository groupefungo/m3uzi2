require_relative 'tag_definition'
require 'uri'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # section-3.4.4
  #
  #
  # Media segments MAY be encrypted.  The EXT-X-KEY tag specifies how to
  # decrypt them.  It applies to every media segment that appears between
  # it and the next EXT-X-KEY tag in the Playlist file with the same
  # KEYFORMAT attribute (or the end of the Playlist file).  Two or more
  # EXT-X-KEY tags with different KEYFORMAT attributes MAY apply to the
  # same media segment, in which case they MUST resolve to the same key.
  # Its format is:
  #
  # #EXT-X-KEY:<attribute-list>
  #
  # The following attributes are defined:
  #
  # METHOD
  # URI
  # IV
  # KEYFORMAT
  # KEYFORMATVERSIONS
  #
  class EXT_X_KEY < AttributeTag
    def initialize(tags, tn = 'EXT-X-KEY')
      @min_version = 1
      @playlist_compatability = PlaylistCompatability::MEDIA

      super(tags, tn)
    end

    def define_attributes(ts)
      ts.create_attributes(%w(METHOD URI IV KEYFORMAT KEYFORMATVERSIONS))
    end

    def define_constraints(ts)
      required_attribute_constraint(ts, 'METHOD')
      nil_value_constraint(ts)
    end

    def define_attribute_constraints(ts)
      define_method_attribute_constraints(ts)
      define_uri_attribute_constraints(ts)
      define_iv_attribute_constraints(ts)
      define_keyformat_attribute_constraints(ts)
      define_keyformatversions_attribute_constraints(ts)
    end

    def define_keyformat_attribute_constraints(ts)
    end


    def define_iv_attribute_constraints(ts)
    end

    def define_keyformatversions_attribute_constraints(ts)
    end

    def define_uri_attribute_constraints(ts)
      ts['URI'] << AttributeConstraint.new('URI is invalid') do | attr |
        attr.value =~ URI::regexp
      end
    end

    def define_method_attribute_constraints(ts)
      restricted_attribute_value_constraint(ts,
        'METHOD', %w(NONE AES-128 SAMPLE-AES))

      value_excludes_attribute_constraint(ts, 'METHOD', 'NONE', 'URI')
    end
  end
end

# Untested - exclusive - not working at 2:12am
# ts['METHOD'].add_constraint do | attr |
# %w(URI IV KEYFORMAT KEYFORMATVERSIONS).each do | k |
## valid_attribute?('METHOD', k) ? false : true
# end unless val == 'NONE'
# end
