require_relative 'base'

module BrainDamage
  class HasOne < Relation
    def initialize(options = {})
      @options = options
    end

    def model_lines
      [relationship_line]
    end

    def relationship_line
      line = "has_one :#{@options[:field].name}".indent
      add_options_to_line line, @options.slice(:class_name, :join_table, :dependent)
    end
  end
end
