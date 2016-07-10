require 'erb'
require 'erubis'
require_relative '../ruby_simple_parser/parser'

module BrainDamage
  module Templateable
    class Base
      attr_reader :options
      attr_reader :inner_html
      attr_accessor :template_file

      def initialize(resource, options = {})
        @options = options
        @resource = resource
        @template_file = "#{self.class.to_s.split('::').last.underscore}.html.haml" unless @template_file
      end

      def render_erb_file(file)
        raise "Trying to render a file that doesn't exist: #{file}" unless File.file? file
        render_erb_string(File.open(file).read)
      end

      def render_erb_string(string)
        return Erubis::Eruby.new(string).result(binding).strip.gsub(/\n\n\n+/, "\n").gsub(/NEW_LINE_\d+/, "") if string.is_a? String
        ''
      end

      def render_template_file(template_file = @template_file)
        render_erb_file "#{dir}/templates/#{template_file}"
      end

      def render(template_file = @template_file)
        render_template_file template_file
      end

      def indent(level = nil)
        level ||= @html_args[:indentation]
        @inner_html.indent! level if level
      end

      def method_missing(method, *args, &block)
        @resource.send method, *args, &block
      end
    end
  end
end
