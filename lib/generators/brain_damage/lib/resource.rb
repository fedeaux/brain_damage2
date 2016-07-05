# -*- coding: utf-8 -*-
require_relative 'includes'

module BrainDamage
  class Resource
    attr_accessor :columns
    attr_accessor :name
    attr_accessor :root

    attr_reader :parametizer
    attr_reader :migration

    def initialize(initializers)
      @parametizer = BrainDamage::Parametizer.new self
      @migration = BrainDamage::Migration.new self
      self.columns = {}

      initializers.each do |initializer|
        instance_eval initializer.read, initializer.path if initializer.is_a? File
      end
    end

    def setup(generator)
      @generator = generator
    end

    def describe(name)
      self.name = name
      yield self if block_given?
    end

    def method_missing(method, *args, &block)
      @generator.send method, *args, &block
    end
  end
end
