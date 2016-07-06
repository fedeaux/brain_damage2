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

    def improve_code(migration_code)
      @migration_lines = migration_code.split "\n"

      return migration_code if @migration_lines.length == 2

      add_options_to_lines
      remake_migration
    end

    def is_column_line? line
      line =~ /t\..*:\w+/
    end

    def add_options_to_lines
      @migration_lines.map! { |line|
        if is_column_line? line
          related_column = line.scan(/:(\w+)/).first.first.to_sym
          column_options = @resource.columns[related_column] || {}

          add_options line, related_column, column_options
        else
          line
        end
      }
    end

    def add_options(line, related_field, field_options)
      options = belongs_to_options line, related_field, field_options

      field_options.slice(:default, :precision, :scale).each do |key, value|
        options << "#{key}: #{value.inspect}"
      end

      options_string = options.join ', '

      if options.length > 0 and !line.include? options_string
        return "#{line}, #{options_string}"
      end

      line
    end

    def belongs_to_options(line, related_field, field_options)
      return [] unless is_belongs_to_line? line
      return ["references: :#{field_options[:class_name].underscore.pluralize}"] if field_options[:class_name]
      []
    end

    def is_belongs_to_line? line
      line.include? 't.belongs_to'
    end

    def remake_migration
      @migration_lines.join "\n"
    end
  end
end
