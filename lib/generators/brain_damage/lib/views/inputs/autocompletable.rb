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

        def value
          "{ display: '\#{#{singular_table_name}.#{name}.try(:#{display_method})}', value: '\#{#{singular_table_name}.#{name}.try(:#{value_method})}'}"
        end

        def display_method
          @options[:display_method] || :name
        end

        def value_method
          @options[:value_method] || :id
        end

        def partial_to_show
          @options[:partial_to_show] || "#{target}/autocompletable/simple_selection"
        end

        def input_name
          @options[:input_name] || render_erb_string("<%= singular_table_name %>[<%= name %>_id]")
        end
      end
    end
  end
end
