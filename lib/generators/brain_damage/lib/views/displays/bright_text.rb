# coding: utf-8
require_relative 'base'

module BrainDamage
  module View
    module Display
      class BrightText < Base
        def value
          text = render_erb_string 'Bright.parse(<%= singular_table_name %>.<%= name %>.gsub("\n", "<br />").gsub(/\s+/, " "))'
        end
      end
    end
  end
end
