require_relative 'constraints'

module M3Uzi2
  # === Description
  #
  class AttributeSpecification
    attr_reader :name,
                :contraints

    def initialize(name)
      @name = name
      @constraints = Constraints.new
    end

    def create_constraint(err_msg, &block)
      @constraints << Constraint.new(err_msg, &block)
    end

    def <<(klass)
      add(klass)
    end

    def add(klass)
      case klass
      when Constraint
        @constraints << klass
      else
        fail "Cannot add a #{klass.class} to a #{self.class}"
      end
    end

    def valid?(attribute)
      @constraints.valid?(attribute)
    end
  end
end
