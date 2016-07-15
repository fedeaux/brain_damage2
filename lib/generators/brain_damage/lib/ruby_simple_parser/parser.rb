require_relative 'block'
require_relative 'method'
require_relative 'code_line'
require_relative 'class_definition'

module RubySimpleParser
  class Parser
    METHOD_START = :method_start
    COMMENT = :comment
    CLASS_START = :class_start
    CODE_WITH_BLOCK = :class_code_with_block
    CODE_WITHOUT_BLOCK = :class_code_without_block
    EMPTY = :empty
    OTHER = :other

    def initialize(code = '')
      @code = code
    end

    def parse
      prepare_to_parse
      @code_lines.each_index do |line_number|
        line_class = classify_line code_line
      end
    end

    def classify_line(code_line)
      if code_line =~ /def (self\.)?\w+/
        METHOD_START

      elsif code_line =~ /^\s*#/
        COMMENT

      elsif code_line =~ /^\s*class\s*/
        CLASS_START

      elsif code_line =~ /(?!.*end\s*$)\w+.*(\{|\bdo\b)[^}]*$/
        CODE_WITH_BLOCK

      elsif code_line =~ /(?!.*end\s*$)^\s*(if|unless|each|while|until|for|begin)[^}]*$/
        CODE_WITH_BLOCK

      elsif code_line.strip == ''
        EMPTY

      else
        CODE_WITHOUT_BLOCK
      end
    end

    def print
      @parsed_code.values.map(&:print).join("\n")+"\n"
    end

    private
    def prepare_to_parse
      @code_lines = code.split("\n")
      @parsed_code = {}
      @context = nil
      @class_method_call_scope = nil

      @public_methods = {}
      @private_methods = {}
      @leading_class_method_calls = []
      @method_scope = :public
    end

  #   attr_reader :class_definition
  #   attr_reader :private_methods
  #   attr_reader :public_methods

  #   attr_accessor :leading_class_method_calls

  #   def parse
  #     @code_lines.each_index do |line_number|
  #       code_line = @code_lines[line_number]
  #       line_class = classify_line code_line

  #       code_line.strip! if line_class == EMPTY

  #       if line_class == PUBLIC_METHOD_START
  #         @parsed_code[line_number] = Method.new code_line, :public
  #         @context = @parsed_code[line_number]

  #       elsif line_class == PRIVATE_METHOD_START
  #         @parsed_code[line_number] = Method.new code_line, :private
  #         @context = @parsed_code[line_number]

  #       elsif line_class == PUBLIC_METHOD_END
  #         if @context and @context.is_a? Method
  #           @context.add_line code_line
  #           @public_methods[@context.name] = @context
  #           @context = nil
  #         end

  #       elsif line_class == PRIVATE_METHOD_END
  #         if @context and @context.is_a? Method
  #           if @context.private?
  #             @context.add_line code_line
  #             @private_methods[@context.name] = @context
  #             @context = nil
  #           elsif @context.public?
  #             @context.add_line(code_line)
  #           end
  #         end

  #       elsif line_class == CLASS_START
  #         @parsed_code[line_number] = ClassDefinition.new code_line
  #         @class_definition = @parsed_code[line_number]
  #         @context = @class_definition

  #       elsif @context and @context.respond_to? :add_line
  #         @context.add_line code_line

  #       else
  #         @parsed_code[line_number] = CodeLine.new code_line

  #         if @context.is_a? ClassDefinition and line_class == CLASS_METHOD_CALL
  #           @leading_class_method_calls << @parsed_code[line_number]
  #         end
  #       end
  #     end

  #     @parsed_code
  #   end
  end
end
