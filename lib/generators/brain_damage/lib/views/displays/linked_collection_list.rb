# coding: utf-8
require_relative 'base'

module BrainDamage
  module View
    module Display
      class LinkedCollectionList < Base
        def item_class
          ''
        end

        def display_class
          ''
        end

        def collapsible?
          true
        end

        def inline_item_divider
          @options[:inline_item_divider] || "', '"
        end
      end
    end
  end
end
