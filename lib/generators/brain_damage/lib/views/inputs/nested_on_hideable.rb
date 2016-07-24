require 'erb'
require_relative 'base'

module BrainDamage
  module View
    module Input
      class NestedOnHideable < Base
        def label_guard?
          true
        end

        def label_guard
          guard
        end

        def guard
          render_erb_string '!defined? nested_on or nested_on.try(:to_sym) != :<%= name %>'
        end
      end
    end
  end
end
