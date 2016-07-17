require_relative 'base'

module BrainDamage
  module Templateable
    class ClassTemplateable < Templateable::Base
      attr_reader :current_file_name

      def initialize(resource, options = {})
        super
        @public_methods_templates = "#{dir}/templates/public_methods/*"
        @private_methods_templates = "#{dir}/templates/private_methods/*"

        @removed_methods = []
      end

      def remove_methods(*methods)
        @removed_methods += methods
      end

      def public_methods
        methods :public
      end

      def private_methods
        methods :private
      end

      def setup(file_name)
        puts "Called setup"
        @current_file_name = file_name
        @current_code = File.read @current_file_name if File.exists? @current_file_name
        extract_definitions
      end

      def generate
        render
      end

      def leading_class_method_calls
        if @parser
          @parser.class_method_calls[:after_class_definition].map(&:print).uniq.join("\n")

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
          definitions[method_name] = method_code unless @removed_methods.include? method_name
        }

        if @parser
          @parser.send("#{visibility}_methods").each do |name, method|
            definitions[name] = method.print
          end
        end

        definitions.values.join("\n\n")
      end

      def extract_definitions
        if @current_code
          @parser = RubySimpleParser::Parser.new @current_code
        else
          @parser = RubySimpleParser::Parser.new
        end
      end

      def class_definition
        @parser.class_definition.definition if @parser
      end
    end
  end
end
