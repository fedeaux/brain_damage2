require_relative 'base'

module BrainDamage
  module ViewSchemas
    class Custom < Base
      def find_views_names
        @views_names = []
      end

      def ensure_views_descriptions
        if File.directory? @resource.root
          custom_views = Dir[ File.join(@resource.root, 'views/**/*') ].select { |file|
            file =~ /\.html\.haml/
          }.map { |file|
            file_name = file.gsub(@resource.root+'/views/', '')

            { name: file_name.gsub('.html.haml', ''), template_name: file, file_name: file_name }
          }

          custom_views.each do |custom_view|
            describe_view custom_view[:name], template_name: custom_view[:template_name], file_name: custom_view[:file_name]
          end
        end
      end

      private
      def self.dir
        __dir__
      end

      def dir
        __dir__
      end
    end
  end
end
