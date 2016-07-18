Dir[File.dirname(__FILE__) + '/base/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/single_page_manager/*.rb'].each {|file| require file }

module BrainDamage
  module ViewSchemas
    class Base
      attr_reader :views

      def initialize(resource)
        @views_names = ['index', 'show', '_fields', '_form'] #, 'show', '_form', '_fields']
        @views = {}
        @resource = resource
      end

      def ensure_views_descriptions
        @views_names.each do |name|
          describe_view name unless @views.has_key? name
        end
      end

      def describe_view(name, options = {})
        # First it tries BrainDamage::View::[SpecificSchemaClass]::[SpecificViewClass]
        # Then it tries BrainDamage::View::[SpecificSchemaClass]::Base
        # If none exists, it will try both again with SpecificSchemaClass.parent, until eventually
        # landing on BrainDamage::View::Base::Base

        schema_class = self.class

        view_class_name = name.gsub('/', '::').camelize

        loop do
          specific_view_class_name = "BrainDamage::View::#{schema_class.name.demodulize}::#{view_class_name}"

          if Object.const_defined? specific_view_class_name
            @views[name] = eval(specific_view_class_name).new @resource, options
            break
          end

          base_view_class_name = "BrainDamage::View::#{schema_class.name.demodulize}::Base"
          if Object.const_defined? base_view_class_name
            klass = eval base_view_class_name

            if klass.has_template? name
              options[:file_name] = "#{name}.html.haml" unless options[:file_name]
              options[:template_name] = "#{name}.html.haml" unless options[:template_name]
              @views[name] = eval(base_view_class_name).new @resource, options
              break
            end
          end

          schema_class = schema_class.superclass

          if schema_class == Object
            puts "ERROR: Unable to find any class capable of rendering the view: #{name}"
            break
          end
        end
      end
    end
  end
end
