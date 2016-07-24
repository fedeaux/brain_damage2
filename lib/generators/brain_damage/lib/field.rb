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
      @invisible = false
    end

    def invisible
      self.display = nil
      self.input = nil
      self.attr_white_list = ''
      @invisible = true
    end

    def invisible?
      @invisible
    end

    def relation= (options)
      options = { type: options } if options.is_a? Symbol
      options[:field] = self
      @relation = Relation.create (@resource.column_relation_type(@name) || options[:type]), options
    end

    def foreign?
      @relation.is_a? Relation
    end

    def model_lines
      return @relation.model_lines if @relation
      []
    end

    def attr_white_list
      @field_white_list = FieldWhiteList.new(self, @attr_white_list) unless @field_white_list
      @field_white_list.list
    end

    def inline_editable(options = {})
      add_display :inline_editable, options
    end

    def display=(options)
      add_display :default, options
    end

    def input=(options)
      add_input :default, options
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

    def inputable?(identifier = :default)
      input = input identifier
      input and input.show?
    end

    def displayable?(identifier = :default)
      display = display identifier
      display and display.show?
    end

    def add_display(identifier, options)
      if options.nil?
        @displays[identifier] = false
      else
        @displays[identifier] = View::Factory.create :display, self, options
      end
    end

    def add_input(identifier, options)
      if options.nil?
        @inputs[identifier] = false
      else
        @inputs[identifier] = View::Factory.create :input, self, options
      end
    end

    def add_label(identifier, options)
      @labels[identifier] = options
    end

    def map_display(identifier, *targets)
      targets.each do |target|
        @displays[target] = @displays[identifier]
      end
    end

    def map_input(identifier, *targets)
      targets.each do |target|
        @inputs[target] = @inputs[identifier]
      end
    end

    def label(scope = :default)
      if @labels[scope]
        return @labels[scope]

      elsif scope == :default
        self.label = { text: render_erb_string("cet('<%= singular_table_name %>.<%= name %>')") }

      else
        puts "ERROR: Unable to find label with scope [#{scope}]"
      end

      label :default
    end

    def input(identifier = :default)
      if @inputs.has_key? identifier
        @inputs[identifier]
      elsif identifier != :default
        input :default
      end
    end

    def display(identifier = :default)
      if @displays.has_key? identifier
        @displays[identifier]
      elsif identifier != :default
        display :default
      end
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
