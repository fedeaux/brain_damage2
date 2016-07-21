# coding: utf-8
require_relative '../../templateable/field_templateable'

module BrainDamage
  module View
    module Display
      class Base < Templateable::FieldTemplateable
        def dir
          __dir__
        end
      end
    end
  end
end
