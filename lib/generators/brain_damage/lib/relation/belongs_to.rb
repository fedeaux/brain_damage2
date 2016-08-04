require_relative 'base'

module BrainDamage
  class BelongsTo < Relation
    def initialize(options = {})
      @options = options
    end

    def white_list
      if @options[:white_list]
        if @options[:white_list] == ''
          return nil
        elsif @options[:white_list].is_a? Array
          return @options[:white_list].map { |field| ":#{field}" }.join ', '
        else
          return @options[:white_list].inspect
        end
      else
        field_name = @options[:field].name.to_s

        unless @options[:polymorphic]
          return ":#{field_name}_id"
        else
          return ":#{field_name}_id, :#{field_name}_type"
        end
      end
    end
  end
end
