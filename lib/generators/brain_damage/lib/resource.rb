# -*- coding: utf-8 -*-
require_relative 'includes'

module BrainDamage
  class Resource
    attr_accessor :name

    attr_reader :root
    attr_reader :columns
    attr_reader :controller
    attr_reader :fields
    attr_reader :model
    attr_reader :views
    attr_reader :migration
    attr_reader :parametizer

    def initialize(initializers, options = {})
      @columns = {}
      @fields = {}
      @root = options[:root]

      @parametizer = BrainDamage::Parametizer.new self
      @migration = BrainDamage::Migration.new self
      @controller = BrainDamage::ControllerGenerator.new self
      @model = BrainDamage::ModelGenerator.new self
      @views = BrainDamage::ViewsGenerator.new self
      @closed_for_field_description = false

      initializers.each do |initializer|
        instance_eval initializer.read, initializer.path if initializer.is_a? File
      end

      ensure_every_column_is_described
    end

    def setup(generator)
      @generator = generator
      ensure_every_column_has_its_generated_attribute_object
    end

    def column_relation_type(column_name)
      return @columns[column_name][:type] if @columns[column_name] and Relation.is_valid_relation? @columns[column_name][:type]
      nil
    end

    def columns=(column_hash)
      column_hash.each do |name, options|
        if options.is_a? Symbol
          @columns[name] = { type: options }
        else
          @columns[name] = options
        end
      end
    end

    def describe(name)
      self.name = name
      yield self if block_given?
    end

    def describe_field(name)
      if @closed_for_field_description
        puts "ERROR: Trying to describe field #{name} after field description has been closed.
      Are you trying to describe a field after describing the views?"
        return
      end

      @fields[name] = Field.new(name: name, resource: self)
      yield @fields[name] if block_given?

      unless @fields[name].relation
        @fields[name].relation = {}
      end
    end

    def describe_controller
      yield @controller if block_given?
    end

    def describe_model
      yield @model if block_given?
    end

    def describe_views
      ensure_every_column_is_described
      yield @views if block_given?
    end

    def inputable_fields(identifier = :default)
      sort_fields(fields.values.select{ |field|
                    field.inputable? identifier
                  })
    end

    def uninputable_fields
      fields.values.reject(&:inputable?)
    end

    def displayable_fields(identifier = :default)
      sort_fields(fields.values.select{ |field|
                    field.displayable? identifier
                  })
    end

    def sort_fields(fields)
      names = @columns.keys
      fields.sort { |field_a, field_b|
        (names.index(field_a.name) || 999) <=>
          (names.index(field_b.name) || 999)
      }
    end

    def displayable_and_inputable_fields(identifier = :default)
      inputable_fields(identifier) & displayable_fields(identifier)
    end

    def ensure_every_column_is_described
      (@columns.keys - @fields.keys).each do |column_name|
        describe_field column_name do |field|
          field.display = :default
          field.input = :default
        end
      end

      uninputable_fields.each do |field|
        field.input = :default unless field.input(:default) == false
      end

      @closed_for_field_description = true
    end

    def ensure_every_column_has_its_generated_attribute_object
      attributes.each do |attribute|
        @fields[attribute.name.to_sym].generated_attribute = attribute
      end
    end

    def method_missing(method, *args, &block)
      @generator.send method, *args, &block
    end
  end
end
