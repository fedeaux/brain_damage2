require_relative 'base'

module BrainDamage
  class BelongsTo < Relation
    def initialize(options = {})
      @options = options
    end
  end
end
