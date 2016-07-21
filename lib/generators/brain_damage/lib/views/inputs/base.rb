# coding: utf-8
require_relative '../../templateable/field_templateable'

module BrainDamage
  module View
    module Input
      class Base < Templateable::FieldTemplateable
        attr_reader :type
        attr_reader :partial_html

        def initialize(field, options)
          super
          @type = self.class.to_s.split('::').last.underscore.to_sym
        end

        def dir
          __dir__
        end
      end
    end
  end
end
