require_relative 'base'

module BrainDamage
  class HasMany < Relation
    def initialize(options = {})
      @options = options
    end
  end
end
