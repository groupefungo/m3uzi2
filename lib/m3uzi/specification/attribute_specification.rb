require_relative 'constraints'

module M3Uzi2
  # === Description
  #
  class AttributeSpecification
    attr_reader :name,
                :contraints

    def initialize(name, &block)
      @name = name
      @constaints = Constraints.new
      @constaints.add(&block) if block_given?
    end

    def add_constraint(&block)
      @constaints.add(&block)
    end

    def valid?(attribute)
      @constaints.valid?(attribute)
    end
  end
end
