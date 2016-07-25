require_relative 'base'

module BrainDamage
  module Templateable
    class FieldTemplateable < Templateable::Base
      attr_reader :type
      attr_reader :partial_html

      def initialize(field, options)
        @field = field
        @type = self.class.to_s.split('::').last.underscore.to_sym

        resource = field.resource
        super resource, options
      end

      def empty_haml_path
        'brain_damage/empty'
      end

      def method_missing(method, *args, &block)
        @field.send method, *args, &block
      end

      def label_guard?
        false
      end

      def show_label?
        true
      end

      def show?
        true
      end

      def render
        super
      end
    end
  end
end
