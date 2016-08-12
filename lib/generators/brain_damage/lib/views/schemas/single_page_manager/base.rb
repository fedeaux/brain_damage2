require_relative '../base/base'

module BrainDamage
  module View
    module SinglePageManager
      class Base < Base::Base
        attr_reader :file_name

        def editable_guard
          '@single_page_manager_options[:editable]'
        end

        def deletable_guard
          '@single_page_manager_options[:deletable]'
        end

        def viewable_guard
          '@single_page_manager_options[:viewable]'
        end

        def default_single_page_manager_options
          {
            editable: true,
            deletable: true,
            viewable: false
          }.inspect
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
