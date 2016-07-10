# coding: utf-8
require_relative 'field_white_list'
require_relative 'relation/base'

module BrainDamage
  class Field
    attr_reader :relation
    attr_writer :attr_white_list
    attr_reader :name

    def initialize(args = {})
      @displays = {}
      @inputs = {}

      @name = args[:name]
      @resource = args[:resource]
    end

    def display=(options)
      add_display :default, options
    end

    def input=(options)
      add_input :default, options
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

    def add_display(identifier, options)
      @displays[identifier] = options
    end

    def add_input(identifier, options)
      @inputs[identifier] = options
    end

    def model_lines
      return @relation.model_lines if @relation

      []
    end

    def attr_white_list
      @field_white_list = FieldWhiteList.new(self, @attr_white_list) unless @field_white_list
      @field_white_list.list
    end
  end
end
