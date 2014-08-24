require_relative 'tag_definition'
require 'uri'

module M3Uzi2
  # http://tools.ietf.org/html/draft-pantos-http-live-streaming-13
  # section-3.4.4
  class EXT_X_KEY < AttributeTag
    def initialize(tags, tn = 'EXT-X-KEY')
      super(tags, tn)
    end

    def define_attributes(ts)
      ts.create_attributes(%w(METHOD URI IV KEYFORMAT KEYFORMATVERSIONS))
    end

    def define_constraints(ts)
      ts << Constraint.new('METHOD attribute is required') do | tag |
        tag.attributes['METHOD'].nil? == false
      end

      ts << Constraint.new("No value allowed for #{ts.name}") do | tag |
        tag.value.nil? == true
      end
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
      ts['URI'] << Constraint.new(
        'URI must only be present if the METHOD is AES-128 or SAMPLE-AES') do | attr |
        %w(AES-128 SAMPLE-AES).include?(attr.parent_tag.attributes['METHOD'].value)
      end

      ts['URI'] << Constraint.new(
        'URI must not be present if METHOD = NONE') do | attr |
        (attr.parent_tag.attributes['METHOD'].value != 'NONE') &&
          !attr.parent_tag.attributes['URI'].nil?
      end

      ts['URI'] << Constraint.new('URI is invalid') do | attr |
        attr.value =~ URI::regexp
      end
    end

    def define_method_attribute_constraints(ts)
      ts['METHOD'] << Constraint.new(
        'valid values for METHOD are NONE AES-128 SAMPLE-AES)') do | attr |
        %w(NONE AES-128 SAMPLE-AES).include?(attr.value)
      end
    end
  end
end

# Untested - exclusive - not working at 2:12am
# ts['METHOD'].add_constraint do | attr |
# %w(URI IV KEYFORMAT KEYFORMATVERSIONS).each do | k |
## valid_attribute?('METHOD', k) ? false : true
# end unless val == 'NONE'
# end
