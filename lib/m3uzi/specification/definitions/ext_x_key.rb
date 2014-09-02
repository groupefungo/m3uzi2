require_relative 'tag_definition'

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

    def define_attributes
      @_ts.create_attributes(%w(METHOD URI IV KEYFORMAT KEYFORMATVERSIONS))
    end

    def define_constraints
      required_attribute_constraint('METHOD')
      nil_value_constraint
    end

    def define_attribute_constraints
      restricted_attribute_value_constraint('METHOD', %w(NONE AES-128 SAMPLE-AES))
      value_excludes_attribute_constraint('METHOD', 'NONE', 'URI')
      value_excludes_attribute_constraint('METHOD', 'NONE', 'IV')
      value_excludes_attribute_constraint('METHOD', 'NONE', 'KEYFORMAT')
      value_excludes_attribute_constraint('METHOD', 'NONE', 'KEYFORMATVERSIONS')

      value_requires_attribute_constraint('METHOD', 'AES-128', 'URI')
      value_requires_attribute_constraint('METHOD', 'SAMPLE-AES', 'URI')

      quoted_string_value_constraint('KEYFORMAT')

      @_ts['IV'] << AttributeConstraint.new('IV is invalid') do | attr |
        _all_int?([attr.value]) && attr.value.to_s[0..1] == '0x'
      end

      quoted_string_value_constraint('KEYFORMATVERSIONS')

      @_ts['KEYFORMATVERSIONS'] << AttributeConstraint.new('KEYFORMATVERSIONS is invalid') do | attr |
        _all_int?(attr.value.tr('"','').split('/'))
      end

      uri_value_constraint('URI')
    end
  end
end
