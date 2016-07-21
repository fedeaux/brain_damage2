require_relative 'base'

module BrainDamage
  module Templateable
    class FieldTemplateable < Templateable::Base
      def initialize(field, options)
        @field = field
        resource = field.resource
        super resource, options
      end

      def method_missing(method, *args, &block)
        @field.send method, *args, &block
      end
    end
  end
end
