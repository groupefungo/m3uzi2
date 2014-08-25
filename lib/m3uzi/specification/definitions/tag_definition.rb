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

      tags[tn] = TagSpecification.new(tn).tap do | ts |
        define_constraints(ts) if self.respond_to? :define_constraints
        define_attributes(ts) if self.respond_to? :define_attributes
        define_attribute_constraints(ts) if self
          .respond_to? :define_attribute_constraints

        ts.min_version = @min_version
        ts.playlist_compatability = @playlist_compatability
      end
    end

    def valid_instance_constraint(ts, range)
      ts << Constraint.new(
        "Tag #{ts.name} may only occur #{range} times.") do | tag |
        true
      end
    end

    def mutual_exclusivity_constraint(ts, arr)
    end
  end

  # Value Tags have a value and no attributes
  class ValueTag < TagDefinition
    def integer_value_constraint(ts)
      ts << Constraint.new("Invalid Value") do | tag |
        begin
          true if Integer(tag.value)
        rescue
          false
        end
      end
    end

    def date_value_constraint(ts)
      require 'time'
      ts << Constraint.new("Invalid Date Value") do | tag |
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

    def nil_value_constraint(ts)
      ts << Constraint.new("The Value Of #{ts.name} must be nil ") do | tag |
        tag.value.nil?
      end
    end
  end

  # Attribute Tags ONLY have attributes and no value
  class AttributeTag < TagDefinition
  end

end
