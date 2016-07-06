require 'spec_helper'
require_relative '../../../lib/generators/brain_damage/lib/ruby_simple_parser/parser'

describe RubySimpleParser::Parser do
  describe '.classify_line' do
    subject { RubySimpleParser::Parser.new '' }

    it 'classifies public method openings' do
      expect(subject.classify_line('  def create')).to eq RubySimpleParser::Parser::PUBLIC_METHOD_START
      expect(subject.classify_line('  def create alface')).to eq RubySimpleParser::Parser::PUBLIC_METHOD_START
      expect(subject.classify_line('  def create(goiaba, limao)')).to eq RubySimpleParser::Parser::PUBLIC_METHOD_START
    end

    it 'classifies public method ending' do
      expect(subject.classify_line('  end')).to eq RubySimpleParser::Parser::PUBLIC_METHOD_END
    end

    it 'classifies private method openings' do
      expect(subject.classify_line('    def create')).to eq RubySimpleParser::Parser::PRIVATE_METHOD_START
      expect(subject.classify_line('    def create alface')).to eq RubySimpleParser::Parser::PRIVATE_METHOD_START
      expect(subject.classify_line('    def create(goiaba, limao)')).to eq RubySimpleParser::Parser::PRIVATE_METHOD_START
      expect(subject.classify_line('    def create(goiaba, limao) #comment')).to eq RubySimpleParser::Parser::PRIVATE_METHOD_START
    end

    it 'classifies private method ending' do
      expect(subject.classify_line('    end')).to eq RubySimpleParser::Parser::PRIVATE_METHOD_END
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

    it 'classifies class method class' do
      expect(subject.classify_line('  before_save :alface')).to eq RubySimpleParser::Parser::CLASS_METHOD_CALL
      expect(subject.classify_line('  include Autocompletable')).to eq RubySimpleParser::Parser::CLASS_METHOD_CALL
      expect(subject.classify_line('  set_before_filter :alface, only: [:queijo] ')).to eq RubySimpleParser::Parser::CLASS_METHOD_CALL
    end

    it 'classifies everything else as other' do
      expect(subject.classify_line('        if @contact.errors.empty?')).to eq RubySimpleParser::Parser::OTHER
    end
  end

  describe '.parse' do
    it 'parses a well formatted rb file' do
      parser = RubySimpleParser::Parser.new File.read 'spec/lib/ruby_simple_parser/examples/controller.rb'
      expect(parser.public_methods[:update].print).to eq File.read('spec/lib/ruby_simple_parser/examples/update.rb').chomp
      expect(parser.leading_class_method_calls.map(&:print).first).to eq "  before_action :set_contact, only: [:show, :edit, :update, :destroy]"
    end
  end

  describe '.print' do
    it 'prints the original code' do
      code = File.read 'spec/lib/ruby_simple_parser/examples/controller.rb'
      parser = RubySimpleParser::Parser.new code
      expect(parser.print).to eq code
    end
  end
end
