require_relative '../templateable/Base'
require_relative 'schemas/factory'

module BrainDamage
  class ViewsGenerator
    def initialize(resource)
      @schemas = []
      @resource = resource
    end

    def generate
    end

    def add_schema(name)
      name = name.to_s
      schema = BrainDamage::ViewSchemas::Factory.create name
      @schemas << schema
      yield schema if block_given?
      schema.ensure_views_descriptions
    end

    private
    def dir
      __dir__
    end
  end
end
