require_relative 'base'

module BrainDamage
  class HasManyAndBelongsToMany < Relation
    def initialize(options = {})
      @options = options
    end
  end
end
