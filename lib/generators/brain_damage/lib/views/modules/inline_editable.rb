# coding: utf-8
require_relative '../../templateable/field_templateable'

module BrainDamage
  module View
    class InlineEditable < Templateable::FieldTemplateable
      def initialize(field, options)
        super
      end

      def dir
        __dir__
      end
    end
  end
end
