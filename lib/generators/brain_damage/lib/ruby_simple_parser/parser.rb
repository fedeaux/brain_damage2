require_relative 'ruby_simple_parser'
require_relative 'block'
require_relative 'class_definition'
require_relative 'code_line'
require_relative 'global_context'
require_relative 'method'
require_relative 'line_classifier'

module RubySimpleParser
  class Parser
    def initialize(code = '')
      @code = code
      @line_classifier = LineClassifier.new
      @methods = {
        public: {},
        private: {}
      }
    end

    def public_methods
      @methods[:public]
    end

    def private_methods
      @methods[:private]
    end

    def parse
      prepare_to_parse

      @code_lines.each_index do |line_number|
        line_code = @code_lines[line_number]
        line_class = @line_classifier.classify line_code

        if [CLASS_START, CODE_WITH_BLOCK].include? line_class
          new_block = eval("RubySimpleParser::#{line_class}").new line_code, @context
          @context = new_block
          # puts "Entered context: #{@context.name}"

        elsif line_class == METHOD_START
          new_block = RubySimpleParser::Method.new line_code, @method_scope, @context
          @context = new_block
          @methods[@method_scope][new_block.name] = new_block
          # puts "Entered context: #{@context.name}"

        elsif line_class == PRIVATE_BLOCK
          @method_scope = :private
          RubySimpleParser::CodeLine.new line_code, @context

        else
          new_block = RubySimpleParser::CodeLine.new line_code, @context

          if line_class == BLOCK_END
            if @context.parent
              # puts "Left context #{@context.name} and entered #{@context.parent.name}"
              @context = @context.parent
            end
          end
        end
      end
    end

    def print
      @global_context.print
    end

    private
    def prepare_to_parse
      @code_lines = @code.split("\n")
      @parsed_code = {}
      @global_context = GlobalContext.new
      @context = @global_context
      @class_method_call_scope = nil

      @leading_class_method_calls = []
      @method_scope = :public
    end
  end
end
