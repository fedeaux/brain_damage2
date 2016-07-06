require 'spec_helper'
require_relative '../../../lib/generators/brain_damage/lib/ruby_simple_parser/parser'

describe RubySimpleParser::Method do
  describe '.initialize' do
    it 'initializes with the first line, assigning correctly the method name' do
      expect(RubySimpleParser::Method.new('def alface', :public).name).to eq :alface
      expect(RubySimpleParser::Method.new('def alface_crespa?', :public).name).to eq :alface_crespa?
      expect(RubySimpleParser::Method.new('def alface_crespa?(scope, goiabada: nil)', :public).name).to eq :alface_crespa?
    end
  end

  describe '.add_line and print' do
    it 'can be added lines and output a string with the whole method' do
      method = RubySimpleParser::Method.new('def alface', :public)

      method.add_line '  10.times do |i|'
      method.add_line '    puts "#{i} alfaces"'
      method.add_line '  end'
      method.add_line 'end'

      expect(method.print).to eq 'def alface
  10.times do |i|
    puts "#{i} alfaces"
  end
end'
    end
  end
end
