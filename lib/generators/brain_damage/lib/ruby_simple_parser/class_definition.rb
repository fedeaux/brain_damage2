module RubySimpleParser
  class ClassDefinition < Block
    CLASS_REGEX = /class\s+(?<class_name>\w+)/

    def initialize(definition, visibility, parent = nil)
      super definition, parent
      @visibility = visibility
      @name = ClassDefinition.extract_class_name definition
    end

    def self.extract_class_name(code)
      (code.match CLASS_REGEX)[:class_name].to_sym
    end
  end
end
