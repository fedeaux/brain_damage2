require 'erb'
require_relative 'base'

module BrainDamage
  module View
    module Input
      class Autocompletable < Base
        def target
          @options[:target]
        end

        def url
          @options[:url] || "/#{@options[:target]}/autocomplete"
        end

        def display_method
          @options[:display_method] || :name
        end

        def value_method
          @options[:value_method] || :id
        end
      end
    end
  end
end
