# coding: utf-8
require_relative '../../templateable/field_templateable'

module BrainDamage
  module View
    module Display
      class Hidden < Templateable::FieldTemplateable
        def dir
          __dir__
        end

        def show?
          false
        end

        def show_label?
          false
        end

        def label_guard?
          false
        end
      end
    end
  end
end
