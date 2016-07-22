# coding: utf-8
require_relative 'base'

module BrainDamage
  module View
    module Display
      class InlineEditable < Base
        def initialize(field, options)
          super
          @if = options[:if] || nil
        end

        def conditions?
          false
        end

        def display(identifier = :inline_editable_display)
          field.display identifier
        end

        def input(identifier = :default)
          field.input identifier
        end
      end
    end
  end
end
