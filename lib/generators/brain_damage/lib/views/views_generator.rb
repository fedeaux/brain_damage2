require_relative '../templateable/Base'
require_relative 'schemas/factory'

module BrainDamage
  class ViewsGenerator
    def initialize(resource)
      @schemas = []
      @views = {}
      @resource = resource
    end

    def generate
    end

    def add_schema(name)
      schema = BrainDamage::ViewSchemas::Factory.create name, @resource
      @schemas << schema
      yield schema if block_given?
      schema.ensure_views_descriptions

      @views.merge! schema.views
    end

    def views
      @views.values
    end

    private
    def dir
      __dir__
    end
  end
end
