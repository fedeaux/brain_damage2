require_relative '../base/base'

module BrainDamage
  module View
    module Autocompletable
      class Base < Base::Base
        def display_method
          @options[:display_method] || :name
        end

        def value_method
          @options[:value_method] || :id
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
