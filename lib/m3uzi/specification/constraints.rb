module M3Uzi2
  class ConstraintError
    attr_reader :message,
                :location,
                :code

    def initialize(message, &block)
      @message = message
      @location = block.source_location if block_given?
    end

    def to_s
      message = "#{@message} "
    end
  end

  class Constraint
    attr_reader :error

    def initialize(err_msg, &block)
      @block = block
      @error = ConstraintError.new(err_msg, &block)
    end

    def test(tag_or_attibute)
      @block.call(tag_or_attibute) ? true : false
    end
  end

  class AttributeConstraint < Constraint
    def handle_error(attr)
      err_msg = "WARNING!! " \
        "#{attr.kind_of?(Attribute) ? attr.parent_tag.name + '#' : ''}"\
        "#{attr.name} "\
        "Failed Against Constraint With Error: "\
        "#{error} (VALUE=#{attr.value})"
      puts err_msg
    end
  end

  class TagConstraint < Constraint
    def handle_error(tag)
      err_msg = "WARNING!! " \
        "#{tag.name} "\
        "Failed Against Constraint With Error: "\
        "#{error} (VALUE=#{tag.value})"
      puts err_msg
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

    def <<(constraint)
      add(constraint)
    end

    def add(constraint)
      case constraint
      when Constraint
        @constraints << constraint
      else
        fail "Attempted to add #{constraint.class} to constraints"
      end
    end

    def valid?(attr_or_tag)
      @constraints.each do | constraint |
        unless constraint.test(attr_or_tag)
          constraint.handle_error(attr_or_tag)
          return false
        end
      end
      true
    end
  end
end
