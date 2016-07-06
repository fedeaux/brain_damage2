module BrainDamage
  class FullGenerator < Rails::Generators::Base
    class_option :descriptions, desc: "The .rb files", :optional => true, :default => '*'
    class_option :destroy, desc: "Destroy instead of creat", :optional => true, :default => false
    class_option :force, desc: "Rewrite files", :optional => true, :default => false

    def just_do_it
      action = options[:destroy] ? 'd' : 'g'

      descriptions = if options[:descriptions] == '*'
        then
          Dir["desc/*"].map { |description|
            file_name = description.split('/').last
            if file_name =~ /\d+\./ then
              file_name
            else
              nil
            end
          }.reject(&:nil?)
      else
        options[:descriptions].split(',').map(&:strip)
      end

      descriptions.each do |description|
        add = if options[:force]
                '--force'
              else
                ''
              end

        cmd = "rails #{action} brain_damage:resource --description=#{description} #{add}"
        puts cmd
        spawn cmd
      end
    end
  end
end
