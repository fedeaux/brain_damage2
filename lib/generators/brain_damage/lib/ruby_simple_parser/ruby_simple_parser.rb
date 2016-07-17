module RubySimpleParser
  CLASS_START = 'ClassDefinition'
  METHOD_START = 'Method'
  CODE_WITH_BLOCK = 'Block'

  CODE_WITHOUT_BLOCK = :class_code_without_block
  EMPTY = :empty
  OTHER = :other
  BLOCK_END = :block_end
  PRIVATE_BLOCK = :private_block
end
