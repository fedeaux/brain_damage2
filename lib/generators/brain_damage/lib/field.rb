# coding: utf-8
require_relative 'field_white_list'
require_relative 'relation/base'
require_relative 'templateable/base'
require_relative 'views/factory'

module BrainDamage
  class Field < Templateable::Base
    attr_reader :name
    attr_reader :relation
    attr_reader :resource

    attr_writer :attr_white_list
    attr_accessor :generated_attribute

    def initialize(args = {})
      @displays = {}
      @inputs = {}
      @labels = {}

      @name = args[:name]
      @resource = args[:resource]
    end

    def invisible
      self.display = nil
      self.input = nil
      self.attr_white_list = ''
    end

    def relation= (options)
      options = { type: options } if options.is_a? Symbol
      options[:field] = self
      @relation = Relation.create (@resource.column_relation_type(@name) || options[:type]), options
    end

    def model_lines
      return @relation.model_lines if @relation
      []
    end

    def attr_white_list
      @field_white_list = FieldWhiteList.new(self, @attr_white_list) unless @field_white_list
      @field_white_list.list
    end

    def display=(options)
      add_display :default, options unless options == nil
    end

    def input=(options)
      add_input :default, options unless options == nil
    end

    def label=(options)
      add_label :default, options
    end

    def has_input?
      @inputs.values.reject(&:nil?).any?
    end

    def has_display?
      @displays.values.reject(&:nil?).any?
    end

    def add_display(identifier, options)
      @displays[identifier] = options
    end

    def add_input(identifier, options)
      @inputs[identifier] = View::Factory.create :input, self, options
    end

    def add_label(identifier, options)
      @labels[identifier] = options
    end

    def label(scope = :default)
      if @labels[scope]
        return @labels[scope]

      elsif scope == :default
        self.label = { text: render_erb_string("cet('<%= singular_table_name %>.<%= name %>')") }

      else
        puts "ERROR: Unable to find label with scope [#{scope}]"
      end

      label(:default)
    end

    def input(identifier = :default)
      @inputs[identifier]
    end

    def display(identifier = :default)
      @displays[identifier]
    end

    def field_type
      if generated_attribute
        generated_attribute.field_type
      else
        :text_field
      end
    end
  end
end
