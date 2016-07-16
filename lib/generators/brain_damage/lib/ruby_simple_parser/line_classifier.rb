module RubySimpleParser
  class LineClassifier
    BLOCK_SPANNING_CONSTRUCTS = ['if', 'unless', 'each', 'while', 'until', 'loop', 'for', 'begin', 'do']

    def classify(original_code_line)
      code_line = original_code_line.strip

      if code_line =~ /def (self\.)?\w+/
        return METHOD_START

      elsif code_line =~ /^\s*#/
        return COMMENT

      elsif code_line =~ /^\s*class\s*/
        return CLASS_START

      elsif code_line == ''
        return EMPTY

      elsif code_line =~ inline_block_spanning_constructs_regex
        return CODE_WITHOUT_BLOCK

      elsif code_line == 'private'
        return PRIVATE_BLOCK

      end

      block_balance = block_balance code_line

      if block_balance > 0
        CODE_WITH_BLOCK
      elsif block_balance < 0
        BLOCK_END
      else
        CODE_WITHOUT_BLOCK
      end
    end

    def inline_block_spanning_constructs_regex
      Regexp.new '\w+\s+\b' + ['if', 'unless', 'while', 'until'].join('\b|\b') + '\b'
    end

    def block_spanning_constructs_regex
      Regexp.new '\b' + BLOCK_SPANNING_CONSTRUCTS.join('\b|\b') + '\b'
    end

    def block_wrappers_regex
      Regexp.new('\b' +  BLOCK_SPANNING_CONSTRUCTS.join('\b|\b') + '\b|\bend\b|\{|\}|\[|\]')
    end

    def strip_block_wrappers(code_line)
      code_line.strip.scan block_wrappers_regex
    end

    def block_balance(code_line)
      balance = 0

      block_wrappers_tokens = strip_block_wrappers code_line

      block_wrappers_tokens.each do |token|
        if BLOCK_SPANNING_CONSTRUCTS.include? token or token == '{' or token == '['
          balance += 1
        elsif ['end', '}', ']'].include? token
          balance -= 1
        end
      end

      balance
    end
  end
end
