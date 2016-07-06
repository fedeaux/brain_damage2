# -*- coding: utf-8 -*-
require_relative 'includes'

module BrainDamage
  class Resource
    attr_accessor :name
    attr_accessor :root

    attr_reader :columns
    attr_reader :controller
    attr_reader :fields
    attr_reader :model
    attr_reader :migration
    attr_reader :parametizer

    def initialize(initializers)
      @columns = {}
      @fields = {}

      @parametizer = BrainDamage::Parametizer.new self
      @migration = BrainDamage::Migration.new self
      @controller = BrainDamage::ControllerGenerator.new self
      @model = BrainDamage::ModelGenerator.new self

      initializers.each do |initializer|
        instance_eval initializer.read, initializer.path if initializer.is_a? File
      end

      ensure_every_column_is_described
    end

    def setup(generator)
      @generator = generator
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
      @fields[name] = Field.new(name: name, resource: self)
      yield @fields[name] if block_given?
    end

    def ensure_every_column_is_described
      (@columns.keys - @fields.keys).each do |column_name|
        describe_field column_name do |field|
          field.display = :default
          field.input = :default
        end
      end
    end

    def method_missing(method, *args, &block)
      @generator.send method, *args, &block
    end
  end
end
