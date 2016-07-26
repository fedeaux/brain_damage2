# coding: utf-8
require_relative 'base'

module BrainDamage
  module View
    module Label
      class Default < Base
        def initialize(field, options)
          super
          @text ||= render_erb_string("cet('<%= singular_table_name %>.<%= name %>')")
        end
      end
    end
  end
end
