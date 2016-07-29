# coding: utf-8
require_relative 'base'

module BrainDamage
  module View
    module Display
      class LinkTo < Base
        def initialize(field, options)
          super
          @display_method = options[:display_method] || name
          @target_method = options[:target_method] || name

          if options[:act_as_foreign]
            self.class.send(:define_method, :foreign?) do
              true
            end
          end
        end

        def link_text
          text = if foreign? then
                   "#{singular_table_name}.#{@target_method}.#{@display_method}"
                 else
                   "#{singular_table_name}.#{@display_method}"
                 end

          return text if text.present?
          link_target
        end

        def link_target
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
