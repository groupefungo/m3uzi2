module M3Uzi2

  class ConstraintError
    attr_reader :message,
                :line,
                :code

    def initialize(message)
      @message = message
    end

    def to_s
      @message
    end
  end

  # TODO: Seperate AttributeConstraints and TagConstraints?
  class Constraint
    def initialize(err_msg, &block)
      @error = ConstraintError.new(err_msg)
      @block = block
    end

    def test(tag_or_attibute)
      @block.call(tag_or_attibute)
    end
  end

  # A constraint is a block of code which will be used to check the validity of
  # a Tag OR Attribute
  class Constraints
    # TODO: add_constraint and valid? in AttributeSpecification and
    # TagSpecification should be mixed in
    def initialize
      @constraints = []
    end

    def add(err_msg, &block)
      @constraints << block
    end

    def valid?(attribute_or_tag)
      @constraints.each do | constraint |
        unless constraint.call(attribute_or_tag)
          puts "#{attribute_or_tag.name} Failed Against Constraint: #{constraint.inspect}"
          return false
        end
      end
      true
    end
  end
end
