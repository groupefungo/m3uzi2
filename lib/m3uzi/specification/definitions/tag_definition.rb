module M3Uzi2
  class TagDefinition
    attr_reader :name

    def initialize(tags, tn)
      @name = tn

      tags[tn] = TagSpecification.new(tn).tap do | ts |
        define_constraints(ts) if self.respond_to? :define_constraints
        define_attributes(ts) if self.respond_to? :define_attributes
        define_attribute_constraints(ts) if self
          .respond_to? :define_attribute_constraints
      end
    end
  end
end
