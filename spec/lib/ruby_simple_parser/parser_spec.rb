require 'spec_helper'
require_relative '../../../lib/generators/brain_damage/lib/ruby_simple_parser/parser'

describe RubySimpleParser::Parser do
  describe '.classify_line' do
    subject { RubySimpleParser::Parser.new '' }

    it 'classifies method openings' do
      expect(subject.classify_line('  def create')).to eq RubySimpleParser::Parser::METHOD_START
      expect(subject.classify_line('  def create alface')).to eq RubySimpleParser::Parser::METHOD_START
      expect(subject.classify_line('  def create(goiaba, limao)')).to eq RubySimpleParser::Parser::METHOD_START
      expect(subject.classify_line('    def create')).to eq RubySimpleParser::Parser::METHOD_START
      expect(subject.classify_line('    def create alface')).to eq RubySimpleParser::Parser::METHOD_START
      expect(subject.classify_line('    def create(goiaba, limao)')).to eq RubySimpleParser::Parser::METHOD_START
    end

    it 'classifies comments' do
      expect(subject.classify_line('# alface')).to eq RubySimpleParser::Parser::COMMENT
      expect(subject.classify_line('   # alface')).to eq RubySimpleParser::Parser::COMMENT
      expect(subject.classify_line('     ### alface')).to eq RubySimpleParser::Parser::COMMENT

      expect(subject.classify_line('  def goiabada ### alface')).not_to eq RubySimpleParser::Parser::COMMENT
    end

    it 'classifies empty lines' do
      expect(subject.classify_line('')).to eq RubySimpleParser::Parser::EMPTY
      expect(subject.classify_line('      ')).to eq RubySimpleParser::Parser::EMPTY
    end

    it 'classifies class definitions' do
      expect(subject.classify_line('class ContactsController < ApplicationController')).to eq RubySimpleParser::Parser::CLASS_START
    end

    it 'classifies code without block' do
      expect(subject.classify_line('  before_save :alface')).to eq RubySimpleParser::Parser::CODE_WITHOUT_BLOCK
      expect(subject.classify_line('  before_save :dominion')).to eq RubySimpleParser::Parser::CODE_WITHOUT_BLOCK
      expect(subject.classify_line('  include Autocompletable')).to eq RubySimpleParser::Parser::CODE_WITHOUT_BLOCK
      expect(subject.classify_line('  set_before_filter :alface, only: [:queijo] ')).to eq RubySimpleParser::Parser::CODE_WITHOUT_BLOCK
      expect(subject.classify_line('  return true if @contact.errors.empty?')).to eq RubySimpleParser::Parser::CODE_WITHOUT_BLOCK
      expect(subject.classify_line('alfaces.map(&:queijo)')).to eq RubySimpleParser::Parser::CODE_WITHOUT_BLOCK
      expect(subject.classify_line('alfaces.map{ |queijo| queijo.goiabada }')).to eq RubySimpleParser::Parser::CODE_WITHOUT_BLOCK
    end

    it 'classifies code with block' do
      expect(subject.classify_line('  scope :alface, -> {')).to eq RubySimpleParser::Parser::CODE_WITH_BLOCK
      expect(subject.classify_line('  scope :alface, -> { |limonada| ')).to eq RubySimpleParser::Parser::CODE_WITH_BLOCK
      expect(subject.classify_line('  validate :queijo, only: do')).to eq RubySimpleParser::Parser::CODE_WITH_BLOCK
      expect(subject.classify_line('  validate :queijo, only: do |alface| ')).to eq RubySimpleParser::Parser::CODE_WITH_BLOCK
      expect(subject.classify_line('        if @contact.errors.empty?')).to eq RubySimpleParser::Parser::CODE_WITH_BLOCK
      expect(subject.classify_line('alfaces.map{ |queijo|')).to eq RubySimpleParser::Parser::CODE_WITH_BLOCK
    end

    it 'classifies everything else as other' do
    end
  end

#   describe '.parse' do
#     it 'parses a well formatted rb file' do
#       parser = RubySimpleParser::Parser.new File.read 'spec/lib/ruby_simple_parser/examples/controller.rb'
#       expect(parser.public_methods[:update].print).to eq File.read('spec/lib/ruby_simple_parser/examples/update.rb').chomp
#       expect(parser.leading_class_method_calls.map(&:print).first).to eq "  before_action :set_contact, only: [:show, :edit, :update, :destroy]"
#     end
#   end

#   describe '.print' do
#     it 'prints the original code' do
#       code = File.read 'spec/lib/ruby_simple_parser/examples/controller.rb'
#       parser = RubySimpleParser::Parser.new code
#       expect(parser.print).to eq code
#     end
#   end
end
