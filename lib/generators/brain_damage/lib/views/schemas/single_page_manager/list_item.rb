require_relative 'base'

module BrainDamage
  module View
    module SinglePageManager
      module List
        class Item < SinglePageManager::Base
          def item_separator
            return '' if @options[:item_separator] == false
            @options[:item_separator] || '.ui.divider'
          end
        end
      end
    end
  end
end
