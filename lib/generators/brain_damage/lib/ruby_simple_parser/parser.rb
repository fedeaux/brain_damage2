require_relative 'method'
require_relative 'code_line'
require_relative 'class_definition'

module RubySimpleParser
  class Parser
    PUBLIC_METHOD_START = :public_method_start
    PUBLIC_METHOD_END = :public_method_end

    PRIVATE_METHOD_START = :private_method_start
    PRIVATE_METHOD_END = :private_method_end

    CLASS_START = :class_start

    COMMENT = :comment
    EMPTY = :empty
    OTHER = :other

    attr_reader :class_definition
    attr_reader :public_methods
    attr_reader :private_methods

    def initialize(code)
      @code_lines = code.split("\n")
      @parsed_code = {}
      @context = nil

      @public_methods = {}
      @private_methods = {}
      parse
    end

    def parse
      @code_lines.each_index do |line_number|
        code_line = @code_lines[line_number]
        line_class = classify_line code_line

        code_line.strip! if line_class == EMPTY

        if line_class == PUBLIC_METHOD_START
          @parsed_code[line_number] = Method.new code_line, :public
          @context = @parsed_code[line_number]

        elsif line_class == PRIVATE_METHOD_START
          @parsed_code[line_number] = Method.new code_line, :private
          @context = @parsed_code[line_number]

        elsif line_class == PUBLIC_METHOD_END
          @context.add_line code_line
          @public_methods[@context.name] = @context
          @context = nil

        elsif line_class == PRIVATE_METHOD_END
          if @context and @context.is_a? Method
            if @context.private?
              @context.add_line code_line
              @private_methods[@context.name] = @context
              @context = nil
            elsif @context.public?
              @context.add_line(code_line)
            end
          end

        elsif line_class == CLASS_START
          @parsed_code[line_number] = ClassDefinition.new code_line
          @class_definition = @parsed_code[line_number]

        elsif @context and @context.respond_to? :add_line
          @context.add_line code_line

        else
          @parsed_code[line_number] = CodeLine.new code_line
        end
      end

      @parsed_code
    end

    def classify_line(code_line)
      if code_line =~ /^  def \w+/
        PUBLIC_METHOD_START

      elsif code_line =~ /^  end/
        PUBLIC_METHOD_END

      elsif code_line =~ /^    def \w+/
        PRIVATE_METHOD_START

      elsif code_line =~ /^    end/
        PRIVATE_METHOD_END

      elsif code_line =~ /^\s*#/
        COMMENT

      elsif code_line =~ /^\s*class\*/
        CLASS_START

      elsif code_line.strip == ''
        EMPTY

      else
        OTHER
      end
    end

    def print
      @parsed_code.values.map(&:print).join("\n")+"\n"
    end
  end
end
