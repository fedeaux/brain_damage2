module BrainDamage
  module View
    module InlineEditable
      module InlineEdit
        class Field < Base
          def initialize(resource, options = {})
            @file_name = "inline_edit/#{options[:field_name]}.html.haml"
            super
          end
        end
      end
    end
  end
end
