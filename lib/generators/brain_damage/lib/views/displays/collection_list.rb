# coding: utf-8
require_relative 'base'

module BrainDamage
  module View
    module Display
      class CollectionList < Base
        def item_class
          ''
        end

        def display_class
          ''
        end

        def collapsible?
          true
        end
      end
    end
  end
end
