class String
  def indent(level = 1, spaces_per_level = 2)
    self.gsub(/^/, ' ' * spaces_per_level.to_i * level.to_i)
  end

  def indent!(level = 1, spaces_per_level = 2)
    self.gsub!(/^/, ' ' * spaces_per_level.to_i * level.to_i)
  end

  def indentation
    length - lstrip.length
  end

  def indentation_level(spaces_per_level = 2)
    indentation / spaces_per_level
  end
end
