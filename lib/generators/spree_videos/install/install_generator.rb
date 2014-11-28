module SpreeVideos
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../../../templates/', __FILE__)

      def add_javascripts
        append_file 'vendor/assets/javascripts/spree/frontend/all.js', "//= require spree/frontend/spree_videos\n" 
      end
      
      def add_stylesheets
        inject_into_file 'vendor/assets/stylesheets/spree/frontend/all.css', " *= require spree/frontend/spree_videos\n", :before => /\*\//, :verbose => true
      end

      def copy_initializer_file
        copy_file 'spree_videos.rb', "config/initializers/spree_videos.rb"
      end

      def add_migrations
        run 'rake railties:install:migrations FROM=spree_videos'
      end

      def run_migrations
         res = ask "Would you like to run the migrations now? [Y/n]"
         if res == "" || res.downcase == "y"
           run 'rake db:migrate'
         else
           puts "Skiping rake db:migrate, don't forget to run it!"
         end
      end
    end
  end
end
