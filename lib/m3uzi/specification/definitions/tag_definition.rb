module M3Uzi2
  class TagDefinition
    attr_reader :name

    INFINITE = 999_999_999_999
    INFINITY = 999_999_999_999

    def initialize(tags, tn)
      @name = tn

      tags[tn] = TagSpecification.new(tn).tap do | ts |
        define_constraints(ts) if self.respond_to? :define_constraints
        define_attributes(ts) if self.respond_to? :define_attributes
        define_attribute_constraints(ts) if self
          .respond_to? :define_attribute_constraints
      end
    end

    def valid_instance_constraint(ts, range)
      ts << Constraint.new("Tag #{ts.name} may only occur #{range} times.") do | tag |
        true
      end
    end

    def mutual_exclusivity_constraint(ts, arr)
    end
  end

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

  class AttributeTag < TagDefinition
  end

end
