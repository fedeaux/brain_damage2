require_relative '../base/base'

module BrainDamage
  module View
    module SinglePageManager
      class Base < Base::Base
        attr_reader :file_name

        def editable_guard
          'true'
        end

        def deletable_guard
          'true'
        end

        def viewable_guard
          '@single_page_manager_options[:viewable]'
        end

        private
        def self.dir
          __dir__
        end

        def dir
          __dir__
        end
      end
    end
  end
end
