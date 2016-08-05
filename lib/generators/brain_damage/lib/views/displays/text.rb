# coding: utf-8
require_relative 'base'

module BrainDamage
  module View
    module Display
      class Text < Base
        def initialize(field, options)
          super
          @display_method = options[:display_method] || name
          @target_method = options[:target_method] || name
        end

        def text
          if foreign?
            "#{singular_table_name}.#{@target_method}.#{@display_method}"
          else
            "#{singular_table_name}.#{@display_method}"
          end
        end

        def display_text
          inner_text = text

          if @options[:filter_method]
            "#{inner_text}.#{@options[:filter_method]}"
          else
            inner_text
          end
        end

        def target
          return "#{singular_table_name}.#{@target_method}" if foreign?
          "#{singular_table_name}"
        end

        def include_existance_check?
          foreign?
        end
      end
    end
  end
end
