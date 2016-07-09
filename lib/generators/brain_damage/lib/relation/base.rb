module BrainDamage
  class Relation
    VALID_RELATION_TYPES = [ :belongs_to, :has_and_belongs_to_many, :has_many, :has_one ]

    def initialize
      raise "class Relation is an abstract class and can't be instantiated"
    end

    def model_lines
      []
    end

    def add_options_to_line(line, options)
      return line unless options
      ([line] + options.map { |name, value|
        if value.is_a? Symbol
          "#{name}: :#{value}"
        else
          "#{name}: '#{value}'"
        end
      }).join ', '
    end

    def self.is_valid_relation? type
      VALID_RELATION_TYPES.include? type
    end

    def self.create(type, options)
      return nil unless Relation.is_valid_relation? type
      "BrainDamage::#{type.to_s.camelize}".constantize.new options
    end
  end
end
