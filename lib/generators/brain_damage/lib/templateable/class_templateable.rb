require_relative 'base'

module BrainDamage
  module Templateable
    class ClassTemplateable < Templateable::Base
      def initialize(resource, options = {})
        super
        @public_methods_templates = "#{dir}/templates/public_methods/*"
        @private_methods_templates = "#{dir}/templates/private_methods/*"
      end

      def public_methods
        methods :public
      end

      def private_methods
        methods :private
      end

      def generate(file_name)
        extract_definitions
        render
      end

      def leading_class_method_calls
        if @parser
          @parser.leading_class_method_calls.map(&:print).uniq.join("\n")
        else
          ''
        end
      end

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

        definitions.values.join("\n\n")
      end

      def extract_definitions
        @parser = RubySimpleParser::Parser.new @current_code if @current_code
      end

      def class_definition
        @parser.class_definition.print if @parser
      end
    end
  end
end
