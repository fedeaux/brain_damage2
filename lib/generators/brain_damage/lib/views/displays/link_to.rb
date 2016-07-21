# coding: utf-8
require_relative 'base'

module BrainDamage
  module View
    module Display
      class LinkTo < Base
        def link_text
          text = if foreign? then
                   "#{singular_table_name}.#{@options[:method]}.#{@options[:display_method]}"
                 else
                   "#{singular_table_name}.#{name}"
                 end

          return text if text.present?
          link_target
        end

        def link_target
          return "#{singular_table_name}.#{@options[:method]}" if foreign?
          "#{singular_table_name}"
        end

        def include_existance_check?
          foreign?
        end
      end
    end
  end
end
