module BrainDamage
  module View
    module InlineEditable
      module InlineEdit
        class Field < Base
          attr_reader :field

          def initialize(resource, options = {})
            @file_name = "inline_edit/#{options[:field].name}.html.haml"
            @field = options[:field]
            super
          end

          def display_class
            ''
          end

          def explicit_edit_action?
            false
          end

          def guard?
            true
          end

          def guard
            ['alface']
          end
        end
      end
    end
  end
end