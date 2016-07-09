require_relative 'base'

module BrainDamage
  class HasAndBelongsToMany < Relation
    def initialize(options = {})
      @options = options
    end

    def model_lines
      [relationship_line]
    end

    def relationship_line
      line = "has_and_belongs_to_many :#{@options[:field].name}".indent
      add_options_to_line line, @options.slice(:class_name, :join_table)
    end
  end
end
