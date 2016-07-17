module RubySimpleParser
  class LineClassifier
    BLOCK_SPANNING_CONSTRUCTS = ['if', 'unless', 'each', 'while', 'until', 'loop', 'for', 'begin', 'do', 'then']

    def classify(original_code_line, apply_normalize: true)
      code_line = if apply_normalize then normalize original_code_line else original_code_line end

      if code_line =~ /def (self\.)?\w+/
        return METHOD_START

      elsif code_line =~ /^\s*class\s*/
        return CLASS_START

      elsif code_line == ''
        return EMPTY

      elsif is_false_block_spanning_construct? code_line
        return CODE_WITHOUT_BLOCK

      elsif code_line == 'private'
        return PRIVATE_BLOCK

      end

      block_balance = block_balance code_line, apply_normalize: false

      if block_balance > 0
        CODE_WITH_BLOCK
      elsif block_balance < 0
        BLOCK_END
      else
        CODE_WITHOUT_BLOCK
      end
    end

    def normalize(original_line)
      line = original_line.strip

      return line if line == ''

      substrings = line.scan(/".*?"|'.*?'/)
      map = {}
      count = 0

      substrings.each do |substring|
        placeholder = "RUBY_SIMPLE_PARSER_STRING_#{count}"
        count += 1
        line.gsub!(substring, placeholder)
        map[placeholder] = substring
      end

      line.split('#').first.strip
    end

    def is_false_block_spanning_construct?(code_line)
      keywords_regex_part = inline_block_spanning_constructs_regex_part

      return false if code_line =~ /.+\s*=\s*#{keywords_regex_part}/ # variable = if condition

      # return if condition then 'a' else 'b' end
      return true if code_line =~ /\breturn\b\s*#{keywords_regex_part}\s+.+\bthen\b.+\bend\b/

      # return if condition then
      #   'a' else 'b' end
      return false if code_line =~ /\breturn\b\s*#{keywords_regex_part}.+\bthen\b.*/

      # return [something] if condition
      return true if code_line =~ /\breturn\b.*#{keywords_regex_part}/

      return true if code_line =~ /[^\s]+.*#{keywords_regex_part}/ # something if condition
    end

    def inline_block_spanning_constructs_regex_part
      '(\b' + ['if', 'unless', 'while', 'until'].join('\b|\b') + '\b)'
    end

    def block_spanning_constructs_regex
      Regexp.new '\b' + BLOCK_SPANNING_CONSTRUCTS.join('\b|\b') + '\b'
    end

    def block_wrappers_regex
      Regexp.new('\b' +  BLOCK_SPANNING_CONSTRUCTS.join('\b|\b') + '\b|\bend\b|\{|\}|\[|\]')
    end

    def strip_block_wrappers(original_code_line, apply_normalize: true)
      code_line = if apply_normalize then normalize original_code_line else original_code_line end
      code_line.strip.scan block_wrappers_regex
    end

    def block_balance(original_code_line, apply_normalize: true)
      code_line = if apply_normalize then normalize original_code_line else original_code_line end
      balance = 0

      block_wrappers_tokens = strip_block_wrappers code_line, apply_normalize: false

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
