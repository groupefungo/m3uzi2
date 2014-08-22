module M3Uzi2
# TODO: Named constraints?
  #       Required vs optional
  #       version

  # A constraint is a block of code which will be
  # used to check the validity of a Tag OR Attribute
  class Constraints
    # TODO: add_constraint and valid? in AttributeSpecification and
    # TagSpecification should be mixed in
    def initialize
      @constraints = []
    end

    def add(&block)
      @constraints << block
    end

    def valid?(attribute_or_tag)
      @constraints.each do | constraint |
        if constraint.call(attribute_or_tag) == false
          puts "#{attribute_or_tag.name} Failed Against Constraint: #{constraint.inspect}"
          return false
        end
      end
      true
    end
  end
end
