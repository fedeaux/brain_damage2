module BrainDamage
  module ViewSchemas
    class Autocompletable < Base
      def initialize(resource)
        @resource = resource
        @views = {}
      end

      def ensure_views_descriptions
        ['_simple_selection', '_multiple_selection', '_links'].each do |name|
          name = "autocompletable/#{name}"
          describe_view(name) unless view_described? name
        end
      end

      def describe_view(name, options = {})
        options = {
          view_class_name: 'Base',
          template_name: "#{name.split('/').last}.html.haml",
          file_name: "#{name}.html.haml"
        }.merge options

        super name, options
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
