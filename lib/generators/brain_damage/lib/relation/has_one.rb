require_relative 'base'

module BrainDamage
  class HasOne < Relation
    def initialize(options = {})
      @options = options
    end
  end
end
