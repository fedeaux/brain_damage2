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

    it 'everything else is other' do
      expect(subject.classify_line('class ContactsController < ApplicationController')).to eq RubySimpleParser::Parser::OTHER
      expect(subject.classify_line('        if @contact.errors.empty?')).to eq RubySimpleParser::Parser::OTHER
    end
  end

  describe '.parse' do
    it 'parses a well formatted rb file' do
      parser = RubySimpleParser::Parser.new File.read 'spec/lib/ruby_simple_parser/examples/controller.rb'
      expect(parser.public_methods[:update].print).to eq %(  def update
    @contact.assign_attributes contact_params

    @contact.save

    respond_to do |format|
      format.json {
        partial = params[:partial_to_show] ? params[:partial_to_show] : 'table.item'
        render json: { html: render_to_string( partial: partial, formats: [:html], locals: get_partial_locals ),
                          errors: @contact.errors }
      }

      format.html {
        if @contact.errors.empty?
          redirect_to @contact, notice: t('common.updated').capitalize
        else
          if params[:request_source]
            render params[:request_source]
          else
            render :edit
          end
        end
      }
    end
  end)
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
