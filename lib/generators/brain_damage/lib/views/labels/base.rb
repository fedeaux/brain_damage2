# coding: utf-8
require_relative '../../templateable/field_templateable'

module BrainDamage
  module View
    module Label
      class Base < Templateable::FieldTemplateable
        attr_reader :text

        def initialize(field, options)
          super

          @text = options[:text]
        end

        def rendered_text
          render_erb_string text
        end

        def dir
          __dir__
        end
      end
    end
  end
end
