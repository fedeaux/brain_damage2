require_relative 'base'

module BrainDamage
  class HasMany < Relation
    def initialize(options = {})
      @options = options
      @name = @options[:field].name
    end

    def model_lines
      [relationship_line, nested_attributes_line, validates_associated_line ]
    end

    def relationship_line
      line = "has_many :#{@name}".indent
      add_options_to_line line, @options.slice(:class_name, :join_table, :as)
    end

    def nested_attributes_line
      "accepts_nested_attributes_for :#{@name}, reject_if: proc { |attributes| attributes.values.uniq.first == '' }".indent
    end

    def validates_associated_line
      "validates_associated :#{@name}".indent
    end
  end
end
