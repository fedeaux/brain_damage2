require_relative '../base/base'

module BrainDamage
  module View
    module NestedFields
      class Base < Base::Base
        attr_reader :file_name

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
