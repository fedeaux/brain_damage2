module RubySimpleParser
  class ClassDefinition < Block
    def initialize(line, parent)
      super line, parent
      @line = line
    end

    def print
      @line
    end
  end
end
