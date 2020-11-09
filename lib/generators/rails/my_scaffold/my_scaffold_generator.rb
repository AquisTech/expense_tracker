require 'rails/generators/rails/scaffold/scaffold_generator'
module Rails
  module Generators
    class MyScaffoldGenerator < ScaffoldGenerator
      def run_datatable_generator
        Rails::Generators.invoke("datatable", [name.pluralize], behavior: behavior)
      end

      def add_datatable_route
        puts "Add datatable compatible routes"
        inject_into_file 'config/routes.rb', after: "concern :with_datatable do
    post :datatable, on: :collection
  end\n" do
          "  resources :#{table_name}, concerns: [:with_datatable]\n"
        end
      end

      def add_datatable_javascript
        template 'datatable.js.erb', "app/assets/javascripts/datatables/#{table_name}_datatable.js.erb"
      end
    end
  end
end