require 'spec_helper'
require_relative '../../../lib/generators/brain_damage/lib/ruby_simple_parser/parser'

describe RubySimpleParser::Parser do
  describe '.parse' do
    it 'parses a well formatted rb file' do
      parser = RubySimpleParser::Parser.new File.read 'spec/lib/ruby_simple_parser/examples/controller.rb'
      expect(parser.public_methods[:update].print).to eq File.read('spec/lib/ruby_simple_parser/examples/update.rb').chomp
      expect(parser.class_method_calls[:after_class_definition].map(&:print).first).to eq "  before_action :set_contact, only: [:show, :edit, :update, :destroy]"

      # parser.class_method_calls[:after_class_definition].each do |line|
      #   puts '---------'
      #   puts line.print
      # end

      # puts parser.public_methods.keys
      # puts parser.private_methods.keys
    end

    it 'parses a complex method' do
      parser = RubySimpleParser::Parser.new File.read 'spec/lib/ruby_simple_parser/examples/complex_method.rb'

      # puts "After class definition:"
      # parser.class_method_calls[:after_class_definition].each do |line|
      #   puts '---------'
      #   puts line.print
      # end

      # puts "Public Methods:"
      # parser.public_methods.values.each do |method|
      #   puts " -- name: #{method.name} --"
      #   puts method.print
      # end

      # puts "Private Methods:"
      # parser.private_methods.values.each do |method|
      #   puts " -- name: #{method.name} --"
      #   puts method.print
      # end

      # puts "[" +parser.public_methods[:"self.from_upload"].print + "]"
    end

    it 'parses another well formatted rb file' do
      parser = RubySimpleParser::Parser.new File.read 'spec/lib/ruby_simple_parser/examples/model.rb'

      # puts "After class definition:"
      # parser.class_method_calls[:after_class_definition].each do |line|
      #   puts '---------'
      #   puts line.print
      # end

      # puts "Public Methods:"
      # parser.public_methods.values.each do |method|
      #   puts " -- name: #{method.name} --"
      #   puts method.print
      # end

      # puts "Private Methods:"
      # parser.private_methods.values.each do |method|
      #   puts " -- name: #{method.name} --"
      #   puts method.print
      # end

      # puts "[" +parser.public_methods[:"self.from_upload"].print + "]"
    end

  end
end
