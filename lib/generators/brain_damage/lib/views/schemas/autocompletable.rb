module BrainDamage
  module ViewSchemas
    class Autocompletable < Base
      def initialize(resource)
        @resource = resource
        @views = {}

        resource.displayable_and_inputable_fields.each do |field|
          describe_view "autocompletable/_simple_selection",
                        view_class_name: 'Base',
                        template_name: '_simple_selection.html.haml',
                        file_name: 'autocompletable/_simple_selection.html.haml'

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
