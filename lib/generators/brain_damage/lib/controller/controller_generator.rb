require_relative '../templateable/base'

module BrainDamage
  class ControllerGenerator < Templateable::Base
    attr_accessor :set_member_before_action_list

    def initialize(resource, options = {})
      @template_file = 'controller.rb'
      @public_methods_templates = "#{dir}/templates/public_methods/*"
      @private_methods_templates = "#{dir}/templates/private_methods/*"

      @set_member_before_action_list = [:show, :edit, :update, :destroy]
      super
    end

    def generate(controller_file_name)
      @controller_file_name = controller_file_name
      @controller_code = File.read @controller_file_name if File.exists? @controller_file_name

      extract_definitions
      render
    end

    def public_methods
      methods :public
    end

    def private_methods
      methods :private
    end

    def leading_class_method_calls
      render_erb_string 'before_action :set_<%= singular_table_name %>, only: <%= set_member_before_action_list.inspect %>'
    end

    def attribute_white_list
      @resource.fields.values.map(&:attr_white_list).reject(&:nil?).join ', '
    end

    private
    def methods(visibility)
      definitions = {}

      identation = if visibility == :public then 1 else 2 end

      Dir[instance_variable_get("@#{visibility}_methods_templates")].map { |template_file|
        method_code = render_erb_file(template_file).indent identation
        method_name = RubySimpleParser::Method.extract_method_name method_code
        definitions[method_name] = method_code
      }

      if @parser
        @parser.send("#{visibility}_methods").each do |name, method|
          definitions[name] = method.print
        end
      end

      definitions.values.join("\n\n")[(identation*2)..-1]
    end

    def extract_definitions
      @parser = RubySimpleParser::Parser.new @controller_code if @controller_code
    end

    def dir
      __dir__
    end
  end
end
