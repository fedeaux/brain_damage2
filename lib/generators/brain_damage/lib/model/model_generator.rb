require_relative '../templateable/class_templateable'

module BrainDamage
  class ModelGenerator < Templateable::ClassTemplateable
    def initialize(resource, options = {})
      @template_file = 'model.rb'
      super
    end

    def generate(model_file_name)
      @model_file_name = model_file_name
      @current_code = File.read @model_file_name if File.exists? @model_file_name
      super
    end

    def attribute_white_list
      @resource.fields.values.map(&:attr_white_list).reject(&:nil?).join ', '
    end

    private
    def dir
      __dir__
    end
  end
end
