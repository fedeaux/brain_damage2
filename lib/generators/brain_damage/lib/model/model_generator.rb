require_relative '../templateable/class_templateable'

module BrainDamage
  class ModelGenerator < Templateable::ClassTemplateable
    def initialize(resource, options = {})
      @template_file = 'model.rb'
      super
    end

    def generate
      improve_belongs_to_lines
      add_lines_from_fields
      prettify_lines
      super
    end

    def prettify_lines
      return if @parser.class_method_calls[:after_class_definition].empty?

      infos = @parser.class_method_calls[:after_class_definition].map { |line|
        code = line.print.strip

        order = if code.starts_with? 'include'
                  0
                elsif code.strip[0, 3].upcase == code.strip[0, 3]
                  1
                elsif code.starts_with? 'default_scope'
                  2
                elsif code.starts_with? 'scope :'
                  3
                elsif code.starts_with? 'validates '
                  4
                elsif code =~ /^(has_many)|(has_and_bel)|(belongs_to)/
                  5
                elsif code.starts_with? 'accepts_nested_attributes_for'
                  6
                elsif code.starts_with? 'validates_associated'
                  7
                else
                  8
                end

        { code: code, line: line, order: order }

      }.sort { |info_a, info_b|
        order = info_a[:order] <=> info_b[:order]
        if order != 0 then order else info_a[:code] <=> info_b[:code] end
      }

      @parser.class_method_calls[:after_class_definition] = []
      current_info = infos.first
      new_line_number = 0

      infos.each do |info|
        if info[:order] != current_info[:order]
          @parser.class_method_calls[:after_class_definition] << RubySimpleParser::CodeLine.new("NEW_LINE_#{new_line_number}")
          new_line_number += 1
          current_info = info
        end

        @parser.class_method_calls[:after_class_definition] << info[:line]
      end
    end

    def attribute_white_list
      @resource.fields.values.map(&:attr_white_list).reject(&:nil?).join ', '
    end

    def improve_belongs_to_lines
      return unless @parser and @parser.class_method_calls[:after_class_definition]

      belongs_to_lines = @parser.class_method_calls[:after_class_definition].each_with_index.map { |line, index|
        [index, line.print]
      }.select{ |pair|
        pair.second =~ /belongs_to :(\w+)\s*$/
      }.map { |pair|
        [pair.first, add_options_to_belongs_to_line(pair.second) ]
      }.each { |pair|
        @parser.class_method_calls[:after_class_definition][pair.first].line = pair.second
      }
    end

    def add_lines_from_fields
      @parser.class_method_calls[:after_class_definition] += @resource.fields.values.map(&:model_lines).flatten.reject(&:nil?).reject(&:empty?).map { |line|
        RubySimpleParser::CodeLine.new line

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
