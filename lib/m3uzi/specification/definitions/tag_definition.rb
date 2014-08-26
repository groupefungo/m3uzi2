module M3Uzi2

  class PlaylistCompatability
    NONE    = 0b00
    MASTER  = 0b01
    MEDIA   = 0b10
    BOTH    = 0b11
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
      define_attribute_constraints if self
        .respond_to? :define_attribute_constraints

      @ts.min_version = @min_version
      @ts.playlist_compatability = @playlist_compatability

      #tags[tn] = TagSpecification.new(tn).tap do | ts |
        #define_constraints(ts) if self.respond_to? :define_constraints
        #define_attributes(ts) if self.respond_to? :define_attributes
        #define_attribute_constraints(ts) if self
          #.respond_to? :define_attribute_constraints

        #ts.min_version = @min_version
        #ts.playlist_compatability = @playlist_compatability
      #end
    end

    def nil_value_constraint(ts)
      ts << TagConstraint.new("The Value Of #{ts.name} must be nil ") do | tag |
        tag.value.nil?
      end
    end

    def valid_instance_constraint(ts, range)
      ts << TagConstraint.new(
        "Tag #{ts.name} may only occur #{range} times.") do | tag |
        true # TODO: implement
      end
    end

    def mutual_exclusivity_constraint(ts, arr)
    end


    def required_attribute_constraint(ts, attr_name)
      ts << TagConstraint.new("Attribute #{ts.name}##{attr_name} is REQUIRED.") do | tag |
        tag.attributes[attr_name].nil? == false
      end
    end

  end

  # Value Tags have a value and no attributes
  class ValueTag < TagDefinition
    def integer_value_constraint(ts)
      ts << TagConstraint.new("Invalid Value") do | tag |
        begin
          true if Integer(tag.value)
        rescue
          false
        end
      end
    end

    def float_value_constraint(ts)

    end


    def date_value_constraint(ts)
      require 'time'
      ts << TagConstraint.new("Invalid Date Value") do | tag |
        begin
          Time.parse(tag.value).iso8601
          true
        rescue
          false
        end
      end
    end
  end

  # IndependentTags have no value and no attributes
  class IndependentTag < TagDefinition
    def define_constraints(ts)
      nil_value_constraint(ts)
    end

  end


  # Attribute Tags ONLY have attributes and no value
  class AttributeTag < TagDefinition

    # Value MUST be a member of arr(ay)
    def restricted_attribute_value_constraint(ts, attr_name, arr)
      msg = "Valid values for #{attr_name} are #{arr.join ','}"
      ts[attr_name] << AttributeConstraint.new(msg) do | attr |
        arr.include?(attr.value)
      end
    end

    # Value MUST be a quoted string.
    def quoted_string_value_constraint(ts, attr_name)
      ts[attr_name] << AttributeConstraint.new(
        "Value for #{ts.name}##{attr_name} must be in matching quotes") do | attr |
        %w(' ").include?(attr.value[0]) && %w(' ").include?(attr.value[-1]) &&
        attr.value[0] ==  attr.value[-1]
      end
    end

    def value_requires_attribute_constraint(ts,
                                            attr_name, value,
                                            required_attr)
      ts[attr_name] << AttributeConstraint.new(
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
    def value_excludes_attribute_constraint(ts,
                                            attr_name, value,
                                            excluded_attr)
      ts[attr_name] << AttributeConstraint.new(
        "#{excluded_attr} must NOT be present if #{self.name} = #{value}") do | attr |
          if (attr.value == value)
            attr.parent_attribute(excluded_attr).nil?
          else
            true
          end
      end
    end

  end

end
