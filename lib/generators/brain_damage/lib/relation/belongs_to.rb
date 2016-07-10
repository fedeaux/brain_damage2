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
        else
          return @options[:white_list].inspect
        end
      else
        return ":#{@options[:field].name.to_s}_id"
      end
    end
  end
end
