require_relative 'autocompletable'

module BrainDamage
  module View
    module Input
      class AutocompletableSimpleSelection < Autocompletable
        def value
          "{ display: '\#{#{singular_table_name}.#{name}.try(:#{display_method})}', value: '\#{#{singular_table_name}.#{name}.try(:#{value_method})}'}"
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
