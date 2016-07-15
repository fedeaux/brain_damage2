module RubySimpleParser
  class Block
    def initialize(definition, parent = nil)
      @parent = parent
      @lines = [definition]
    end

    def add_line(line)
      @lines << line
    end

    def print
      @lines.join "\n"
    end
  end
end
