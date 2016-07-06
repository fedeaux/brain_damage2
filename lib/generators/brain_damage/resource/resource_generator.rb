require 'rails/generators/resource_helpers'
require 'rails/generators/rails/model/model_generator'
require 'active_support/core_ext/object/blank'

require_relative '../lib/resource'
require_relative 'monkeys/string'
require_relative 'helpers'

module BrainDamage
  class ResourceGenerator < Rails::Generators::ModelGenerator
    include Rails::Generators::ModelHelpers
    include Rails::Generators::ResourceHelpers
    include BrainDamage::ResourceHelpers

    source_root File.expand_path('../templates', __FILE__)

    class_option :description, desc: "The .rb file with description for this resource"

    class << self
      attr_accessor :resource
      attr_accessor :resource_root
    end

    def self.start(args, config)
      self.resource = get_resource_description args
      resource.root = resource_root

      args = resource.parametizer.as_cmd_parameters + ['--force', '--no-test-framework', '--no-routes'] # always force views
      @ignore_migration = self.resource.migration.skip?

      if @ignore_migration
        args << '--no-migration'
      end

      hook_for :resource_route, required: true, in: :rails unless self.has_already_added_route?

      super
    end

    def set_resource_object
      @resource = self.class.resource
      @resource.setup self
    end

    def generate_controller
      file_name = File.join('app/controllers', controller_class_path, "#{controller_file_name}_controller.rb")
      create_file(file_name) { @resource.controller.generate(file_name) }
    end

    def generate_model
      file_name = File.join('app/models', "#{@resource.name.underscore.downcase}.rb")
      create_file(file_name) { @resource.model.generate(file_name) }
    end

    def improve_migration_code
      return if @ignore_migration
      file_name = @resource.migration.migration_file_full_path

      return unless file_name and File.exists? file_name
      file_contents = File.read file_name

      File.open(file_name, 'w+') do |f|
        f.write @resource.migration.improve_code file_contents
      end
    end

    protected
    def self.get_resource_description(args)
      initializers = [get_helpers_file, get_description_file_from_args(args)].reject(&:nil?)
      BrainDamage::Resource.new initializers
    end

    def self.get_helpers_file
      helpers_file = Rails.root+'desc/helpers.rb'
      return File.open helpers_file if File.exists? helpers_file
    end

    def self.get_description_file_from_args(args)
      description = args.select{ |arg|
        arg.starts_with? '--description' or arg.starts_with? '-d'
      }.first

      return nil unless description

      file_name = description.split('=').last.strip

      if file_name =~ /^\d+/
        full_file_name = Rails.root+'desc/'+file_name

      else
        # Try to find a directory
        file_glob = '*.'+file_name
        full_file_name = Dir[Rails.root+'desc/'+file_glob].first

        if full_file_name.blank?
          # No directory? Try a file
          file_glob += '.rb'
          full_file_name = Dir[Rails.root+'desc/'+file_glob].first
        end
      end

      if full_file_name.blank?
        raise "Couldn't find any file related with #{description}"
      else
        if File.directory? full_file_name
          self.resource_root = full_file_name
          return File.open "#{resource_root}/#{file_name.gsub(/^\d+\./, '')}.rb"
        end

        return File.open full_file_name
      end
    end

    def self.has_already_added_route?
      File.read(Rails.root+'config/routes.rb').include? "resources :#{resource.name.pluralize.underscore}"
    end

    def handler
      :haml
    end

    def method_missing(method, *args, &block)
      puts "BrainDamage: Failed to delegate #{method} (on: #{self.class.to_s})"
      super
    end
  end
end
