require_relative 'ruby_simple_parser'
require_relative 'block'
require_relative 'class_definition'
require_relative 'code_line'
require_relative 'global_context'
require_relative 'method'
require_relative 'line_classifier'

module RubySimpleParser
  class Parser
    attr_accessor :class_method_calls
    attr_reader :class_definition

    def initialize(code = '')
      @code = code
      @line_classifier = LineClassifier.new
      parse if code
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
        new_block = nil

        if line_class == CLASS_START
          new_block = RubySimpleParser::ClassDefinition.new line_code, @context
          @context = new_block
          @class_definition = new_block
          # puts "Entered context: #{@context.name}"

        elsif line_class == CODE_WITH_BLOCK
          new_block = RubySimpleParser::Block.new line_code, @context
          @context = new_block

        elsif line_class == METHOD_START
          new_block = RubySimpleParser::Method.new line_code, @method_scope, @context
          @context = new_block
          @methods[@method_scope][new_block.name] = new_block
          @last_method = new_block.name
          # puts "Entered context: #{@context.name}"

        elsif line_class == PRIVATE_BLOCK
          @method_scope = :private
          RubySimpleParser::CodeLine.new line_code, @context

        else
          new_block = RubySimpleParser::CodeLine.new line_code, @context

          if line_class == BLOCK_END
            if @context.parent
              # puts "Left context: #{@context.name} (line_class: #{line_class})"
              @context = @context.parent
            end
          end
        end

        if new_block and (![EMPTY, BLOCK_END].include? line_class) and !new_block.is_a? ClassDefinition and
          (( line_class == CODE_WITH_BLOCK and @context.parent.is_a? ClassDefinition ) or
           @context.is_a? ClassDefinition )

          if @last_method
            @class_method_calls[@last_method] ||= []
            @class_method_calls[@last_method] << new_block
          else
            @class_method_calls[:after_class_definition] << new_block
          end
        end
      end
    end

    def class_method_calls_after(method)
      if @class_method_calls.has_key? method
        @class_method_calls[method]
      else
        []
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

      @methods = {
        public: {},
        private: {}
      }

      @last_method = nil

      @class_method_calls = { after_class_definition: [] }
      @class_definition = nil

      @method_scope = :public
    end
  end
end
