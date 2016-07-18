Dir[File.dirname(__FILE__) + '/base/*.rb'].each {|file| require file }

module BrainDamage
  module ViewSchemas
    class Base
      attr_reader :views

      def initialize(resource)
        @views_names = ['index'] #, 'show', '_form', '_fields']
        @views = {}
        @resource = resource
      end

      def ensure_views_descriptions
        @views_names.each do |name|
          describe_view name unless @views.has_key? name
        end
      end

      def describe_view(name, options = {})
        @views[name] = eval("BrainDamage::View::Base::#{name.camelize}").new @resource
      end
    end
  end
end
