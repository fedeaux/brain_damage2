module BrainDamage
  class Migration
    def initialize(resource)
      @resource = resource
    end

    def migration_file_exists?
      file_name = migration_file_full_path
      file_name && File.exists?(file_name)
    end

    def migration_file_full_path
      Dir["db/migrate/*"].select { |file_name|
        file_name.split('/').last =~ /\d+_create_#{@resource.name.underscore.pluralize}.rb/
      }.first
    end

    alias_method :skip?, :migration_file_exists?
  end
end
