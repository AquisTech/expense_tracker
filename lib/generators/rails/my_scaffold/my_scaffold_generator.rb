module Rails
  module Generators
    class MyScaffoldGenerator < Rails::Generators::NamedBase
      def generate_model_file
        return if behavior == :revoke
        unless File.exists?("app/models/#{singular_table_name}.rb")
          puts 'Generate blank model file reference table from'
          create_file "app/models/#{singular_table_name}.rb"
          append_file "app/models/#{singular_table_name}.rb", "class #{name} < ApplicationRecord\nend"
        end
      end

      def run_scaffold_generator
        puts 'Running scaffold generator'
        Rails::Generators.invoke('scaffold', [name, '--no-migration', '--no-resource-route'], behavior: behavior)
      end

      def run_datatable_generator
        puts 'Running datatable generator'
        Rails::Generators.invoke('datatable', [name.pluralize], behavior: behavior)
      end

      def add_datatable_route
        puts 'Add datatable compatible routes'
        inject_into_file 'config/routes.rb', after: "concern :with_datatable do\n    post :datatable, on: :collection\n  end\n" do
          "  resources :#{table_name}, concerns: [:with_datatable]\n"
        end
      end

      def add_datatable_javascript
        template 'datatable.js.erb', "app/assets/javascripts/datatables/#{table_name}_datatable.js.erb"
      end

      def run_rspec_generator
        puts 'Running rspec generator'
        Rails::Generators.invoke('rspec:model', [name, '--dir=spec/factories'], behavior: behavior)
      end
    end
  end
end