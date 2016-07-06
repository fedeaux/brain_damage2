require_relative '../templateable/class_templateable'

module BrainDamage
  class ModelGenerator < Templateable::ClassTemplateable
    def initialize(resource, options = {})
      @template_file = 'model.rb'
      super
    end

    def generate(model_file_name)
      @model_file_name = model_file_name
      @current_code = File.read @model_file_name if File.exists? @model_file_name

      extract_definitions
      improve_belongs_to_lines
      render
    end

    def attribute_white_list
      @resource.fields.values.map(&:attr_white_list).reject(&:nil?).join ', '
    end

    def improve_belongs_to_lines
      return unless @parser.leading_class_method_calls

      belongs_to_lines = @parser.leading_class_method_calls.each_with_index.map { |line, index|
        [index, line.print]
      }.select{ |pair|
        pair.second =~ /belongs_to :(\w+)\s*$/
      }.map { |pair|
        [pair.first, add_options_to_belongs_to_line(pair.second) ]
      }.each { |pair|
        @parser.leading_class_method_calls[pair.first].line = pair.second
      }
    end

    def add_options_to_belongs_to_line(line)
      related_field = line.scan(/:(\w+)/).first.first.to_sym
      options = @resource.columns[related_field].dup
      options.delete :type

      options = options.map { |key, value|
        "#{key}: '#{value}'"
      }

      if options.any?
        "#{line}, #{options.join(', ')}"
      else
        line
      end
    end

    private
    def dir
      __dir__
    end
  end
end
