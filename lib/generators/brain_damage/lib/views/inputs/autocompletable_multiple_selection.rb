require_relative 'autocompletable'

module BrainDamage
  module View
    module Input
      class AutocompletableMultipleSelection < Autocompletable
        def values
          "if #{singular_table_name}.#{name}.any? then #{value} else 'null' end"
        end

        def value
          "#{singular_table_name}.#{name}.map { |item| { display: item.#{display_method}, value: item.#{value_method} }}.to_json"
        end

        def partial_to_show
          @options[:partial_to_show] || "#{target}/autocompletable/multiple_selection"
        end

        def input_name
          @options[:input_name] || render_erb_string("<%= singular_table_name %>[<%= name.to_s.singularize %>_ids][]")
        end
      end
    end
  end
end
