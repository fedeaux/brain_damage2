require_relative 'field_white_list'

module BrainDamage
  class Field
    attr_accessor :relation
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
      display = nil
      input = nil
      attr_white_list = ''
    end

    def describe_relation(type, options = {})
      # Relation::Factory.build type, options
    end

    def add_display(identifier, options)
      @displays[identifier] = options
    end

    def add_input(identifier, options)
      @inputs[identifier] = options
    end

    def attr_white_list
      @field_white_list = FieldWhiteList.new(self, @attr_white_list) unless @field_white_list
      @field_white_list.list
    end
  end
end
