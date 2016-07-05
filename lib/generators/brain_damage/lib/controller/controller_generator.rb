require_relative '../templateable/base'

module BrainDamage
  class ControllerGenerator < Templateable::Base
    attr_accessor :set_member_before_action_list

    def initialize(resource, options = {})
      @template_file = 'controller.rb'
      @public_methods_templates = "#{dir}/templates/methods/*"

      @set_member_before_action_list = [:show, :edit, :update, :destroy]
      super
    end

    def generate(controller_file_name)
      @controller_file_name = controller_file_name
      @controller_code = File.read @controller_file_name if File.exists? @controller_file_name

      extract_definitions
      render
    end

    def extract_definitions
      if @controller_code
      end
    end

    def public_methods
      Dir[@public_methods_templates].map { |template_file|
        # method_name = template_file.split('/').last.gsub('.rb', '')
        render_erb_file template_file
      }.join("\n\n").indent(1)[2..-1]
    end

    def attribute_white_list
      @resource.fields.values.map(&:attr_white_list).reject(&:nil?).join ', '
    end

    def dir
      __dir__
    end
  end
end
