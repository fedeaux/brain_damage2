require_relative '../templateable/class_templateable'

module BrainDamage
  class ControllerGenerator < Templateable::ClassTemplateable
    attr_accessor :set_member_before_action_list

    def initialize(resource, options = {})
      @template_file = 'controller.rb'
      @set_member_before_action_list = [:show, :edit, :update, :destroy]
      super
    end

    def generate(controller_file_name)
      @controller_file_name = controller_file_name
      @current_code = File.read @controller_file_name if File.exists? @controller_file_name
      super
    end

    def leading_class_method_calls
      render_erb_string 'before_action :set_<%= singular_table_name %>, only: <%= set_member_before_action_list.inspect %>'
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
