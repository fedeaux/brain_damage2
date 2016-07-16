module RubySimpleParser
  class GlobalContext < Block
    def initialize
      super(nil, nil)
      @name = 'Global'
    end
  end
end
