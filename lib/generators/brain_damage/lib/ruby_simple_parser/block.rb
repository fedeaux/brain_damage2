module RubySimpleParser
  class Block
    attr_reader :parent
    attr_reader :lines
    attr_reader :name

    def initialize(definition, parent = nil)
      @parent = parent
      @lines = []

      if definition
        @name = "[#{definition.strip[0, 10]}...]"
        RubySimpleParser::CodeLine.new(definition, self)
      else
        @name = :undefined_block
      end

      parent.add_line self if parent
    end

    def add_line(line)
      if line.is_a? String
        CodeLine.new line, self
      else
        @lines << line
      end
    end

    def print
      @lines.map(&:print).join "\n"
    end
  end
end
