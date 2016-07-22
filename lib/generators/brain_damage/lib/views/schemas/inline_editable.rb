module BrainDamage
  module ViewSchemas
    class InlineEditable < Base
      def initialize(resource)
        @resource = resource
        @views = {}

        describe_view 'inline_edit/_inline_edit'

        resource.displayable_and_inputable_fields.each do |field|
          describe_view "inline_edit/_#{field.name}", view_class_name: 'InlineEdit::Field', field_name: field.name
        end
      end

      def ensure_views_descriptions
      end

      private
      def self.dir
        __dir__
      end

      def dir
        __dir__
      end
    end
  end
end
