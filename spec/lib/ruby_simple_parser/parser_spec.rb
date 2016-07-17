require 'spec_helper'
require_relative '../../../lib/generators/brain_damage/lib/ruby_simple_parser/parser'

describe RubySimpleParser::Parser do
  describe '.parse' do
    it 'parses a well formatted rb file' do
      parser = RubySimpleParser::Parser.new File.read 'spec/lib/ruby_simple_parser/examples/controller.rb'
      parser.parse
      expect(parser.public_methods[:update].print).to eq File.read('spec/lib/ruby_simple_parser/examples/update.rb').chomp
  #     expect(parser.leading_class_method_calls.map(&:print).first).to eq "  before_action :set_contact, only: [:show, :edit, :update, :destroy]"
  #   end
    end
  end

#   describe '.print' do
#     it 'prints the original code' do
#       code = File.read 'spec/lib/ruby_simple_parser/examples/controller.rb'
#       parser = RubySimpleParser::Parser.new code
#       expect(parser.print).to eq code
#     end
#   end
end
