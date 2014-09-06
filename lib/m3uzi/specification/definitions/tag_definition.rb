require 'uri'

module M3Uzi2


  # There are severl tags which can be used either in a media playlist or a
  # master playlist, but not both. There are several tags which can be used
  # in both types of play list. This class gives us:
  #
  # 1) Constants to label the type of list the tag is compatable with.
  # 2) a means to check if any of the tags in the headers and playlist of
  #    a file violate the rules.
  #
  class PlaylistCompatability
    NONE    = 0b11
    MASTER  = 0b01
    MEDIA   = 0b10
    BOTH    = 0b00

    # a valid set of headers + playlist should return either 0, 1 or 2
    # if the value >= NONE (i.e. 3) then a tag is present which shouldnt be
    def self.check(headers, playlist)
      (or_array(headers) | or_array(playlist)) < NONE
    end

    # or every value in the array with the previous result.
    def self.or_array(arr)
      arr.inject(0b00) { | e, a | a.playlist_compatability | e }
    end
  end


  class TagDefinition
    attr_reader :name,
                :min_version,
                :playlist_compatability

    INFINITE = 999_999_999
    INFINITY = 999_999_999

    def initialize(tags, tn)
      @name = tn

      tags[tn] = (@_ts = TagSpecification.new(@name))

      define_constraints if self.respond_to? :define_constraints
      define_attributes if self.respond_to? :define_attributes
      define_attribute_constraints if self.respond_to? :define_attribute_constraints

      # TODO: Deprecate
      @_ts.min_version = @min_version
      @_ts.playlist_compatability = @playlist_compatability
    end

    def nil_value_constraint
      @_ts << TagConstraint.new(
        "The Value Of #{@_ts.name} must be nil ") do | tag |
        tag.value.nil?
      end
    end

    def min_version_constraint(version)
      @_ts.min_version = version
    end

    def playlist_compatability_constraint(ps)
      @_ts.playlist_compatability = ps
    end

    def valid_occurance_constraint(range)
      @_ts.valid_occurance_range = range
    end

    #def valid_instance_constraint(range)
      #@_ts << TagConstraint.new(
        #"Tag #{@_ts.name} may only occur #{range} times.") do | tag |
        #true # TODO: implement
      #end
    #end

    def mutual_exclusivity_constraint(arr)
    end

    def required_attribute_constraints(arr)
      arr.each { | attr_name | required_attribute_constraint(attr_name) }
    end

    def required_attribute_constraint(attr_name)
      @_ts << TagConstraint.new(
        "Attribute #{@_ts.name}##{attr_name} is REQUIRED.") do | tag |
        tag.attributes[attr_name].nil? == false
      end
    end

    protected

    def strip_quotes(str)
      qs = ['\'', '"']
      str[(qs.include?(str[0]) ? 1 : 0) .. (qs.include?(str[-1]) ? -2 : -1)]
    end

    def _split_val(str, chr)
      if (pos = str.to_s.index(chr))
        return [str[0..pos - 1], str[pos + 1..-1]]
      end

      str
    end

    def _all_int?(args)
      [*args].all? { | i | Integer(i) }
    rescue
      false
    end

  end

  ###########################################################################
  #
  # ValueTag
  #
  ###########################################################################

  # Value Tags have a value and no attributes
  class ValueTag < TagDefinition
    def restricted_value_constraint(arr)
      @_ts << TagConstraint.new("Invalid Restricted Value") do | tag |
        arr.include?(tag.value)
      end
    end

    def integer_value_constraint(range = nil)
      @_ts << TagConstraint.new("Invalid Integer Value") do | tag |
        begin
          true if Integer(tag.value) && (range ? range.include?(tag.value) : true)
        rescue
          false
        end
      end
    end

    def byte_range_constraint
      @_ts << TagConstraint.new("Invalid Byte Range Value") do | tag |
        _all_int?(_split_val(tag.value.to_s, '@'))
      end
    end

    def float_value_constraint
    end

    def date_value_constraint
      require 'time'
      @_ts << TagConstraint.new("Invalid Date Value") do | tag |
        begin
          Time.parse(tag.value).iso8601
          true
        rescue
          false
        end
      end
    end
  end

  ###########################################################################
  #
  # IndependentTag
  #
  ###########################################################################
  # IndependentTags have no value and no attributes
  class IndependentTag < TagDefinition
    def define_constraints
      nil_value_constraint
    end
  end

  ###########################################################################
  #
  # AttributeTag
  #
  ###########################################################################
  # Attribute Tags ONLY have attributes and no value
  class AttributeTag < TagDefinition

    def decimal_resolution_value_constraint(attr_name)
      @_ts[attr_name] << AttributeConstraint.new(
        "Value must be of the form <integer>x<integer>") do | tag |
        _all_int?(_split_val(tag.value.to_s, 'x'))
      end
    end

    # Helper - define several at once
    def integer_value_constraints(arr)
      arr.each { | attr_name | integer_value_constraint(attr_name) }
    end

    def uri_value_constraint(attr_name)
      @_ts[attr_name] << AttributeConstraint.new('Value must be a URI') do | attr |
        true # attr.value.tr("\"", '') =~ URI::regexp
      end
    end

    def integer_value_constraint(attr_name)
      @_ts[attr_name] << AttributeConstraint.new('Value must be an Integer') do | attr |
        _all_int?([attr.value])
      end
    end

    # Helper - define several at once
    def restricted_attribute_value_constraints(att_arr, arr)
      att_arr.each do | attr_name |
        restricted_attribute_value_constraint(attr_name, arr)
      end
    end

    # Value MUST be a member of arr(ay)
    def restricted_attribute_value_constraint(attr_name, arr)
      msg = "Valid values for #{attr_name} are #{arr.join ','}"
      @_ts[attr_name] << AttributeConstraint.new(msg) do | attr |
        arr.include?(attr.value)
      end
    end

    def byte_range_attribute_constraint(attr_name)
      @_ts[attr_name] << AttributeConstraint.new('Invalid Byte Range Value') do | tag |
        _all_int?(_split_val(strip_quotes(tag.value.to_s), '@'))
      end
    end

    # Helper - define several at once
    def quoted_string_value_constraints(arr)
      arr.each { | attr_name | quoted_string_value_constraint(attr_name) }
    end

    # Value MUST be a quoted string.
    def quoted_string_value_constraint(attr_name)
      @_ts[attr_name] << AttributeConstraint.new(
        "Value for #{@_ts.name}##{attr_name} must be in matching quotes") do | attr |
        %w(' ").include?(attr.value[0]) && %w(' ").include?(attr.value[-1]) &&
        attr.value[0] ==  attr.value[-1]
      end
    end

    # if an attribure is set to a given value then another attribute
    # MUST be present
    def value_requires_attribute_constraint(attr_name, value,
                                            required_attr)
      @_ts[attr_name] << AttributeConstraint.new(
        "#{required_attr} is REQUIRED if #{self.name} = #{value}") do | attr |
        if attr.value == value
          !attr.parent_attribute(required_attr).nil?
        else
          true
        end
      end
    end

    # ==== Description
    #
    # ==== Example
    #  value_excludes_attribute(ts, 'METHOD', 'URI', 'NONE')
    #
    #  if the attribute METHOD == NONE then URI attribute must
    #  not be present.
    #
    # ts['METHOD'] << Constraint.new(
    #   'URI must not be present if METHOD = NONE') do | attr |
    #   (attr.value != 'NONE') && !attr.parent_attribute('URI').nil?
    # end
    def value_excludes_attribute_constraint(attr_name, value,
                                            excluded_attr)
      @_ts[attr_name] << AttributeConstraint.new(
        "#{excluded_attr} must NOT be present if LOOK HERE #{self.name} = #{value}") do | attr |
        if attr.value == value
          attr.parent_attribute(excluded_attr).nil?
        else
          true
        end
      end
    end
  end
end
