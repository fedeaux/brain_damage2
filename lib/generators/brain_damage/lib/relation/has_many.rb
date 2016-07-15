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
      add_options_to_line line, @options.slice(:class_name, :join_table, :as, :dependent, :foreign_key, :through)
    end

    def nested_attributes_line
      "accepts_nested_attributes_for :#{@name}, reject_if: proc { |attributes| attributes.values.uniq.first == '' }".indent unless @options[:skip_nested_form]
    end

    def validates_associated_line
      "validates_associated :#{@name}".indent unless @options[:skip_nested_form]
    end

    def white_list
      if @options[:white_list]
        return ":#{@name.to_s.pluralize}_attributes => #{@options[:white_list].inspect}"
      end
    end
  end
end
