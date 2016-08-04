module BrainDamage
  module View
    module InlineEditable
      module InlineEdit
        class Field < Base
          attr_reader :field

          def initialize(resource, options = {})
            @file_name = "inline_edit/_#{options[:field].name}.html.haml"
            @field = options[:field]

            options = {
              multipart: false,
              remote: true
            }.merge options

            super
          end

          def display_class
            ''
          end

          def explicit_edit_action?
            false
          end

          def multipart?
            @options[:multipart]
          end

          def remote?
            @options[:remote]
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
