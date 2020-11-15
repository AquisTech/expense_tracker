if defined?(FactoryBot)
  require "generators/factory_bot/model/model_generator"

  FactoryBot::Generators::ModelGenerator.class_eval do
    private

    IGNORED_FAKER_METHODS = [
      :respond_to_missing?, :method_missing, :fetch, :shuffle, :sample, :rand, :translate, :parse, :with_locale,
      :unique, :numerify, :letterify, :bothify, :regexify, :fetch_all, :flexible, :rand_in_range, :yaml_tag, :new,
      :allocate, :superclass, :subclasses, :json_creatable?, :class_attribute, :descendants, :reachable?, :include,
      :included_modules, :include?, :ancestors, :instance_methods, :public_instance_methods,
      :protected_instance_methods, :private_instance_methods, :constants, :const_get, :const_set, :const_defined?,
      :class_variables, :remove_class_variable, :class_variable_get, :class_variable_set, :class_variable_defined?,
      :public_constant, :private_constant, :deprecate_constant, :singleton_class?, :module_exec, :class_exec,
      :public_method_defined?, :class_eval, :protected_method_defined?, :public_class_method, :psych_yaml_as,
      :method_defined?, :delegate, :remove_possible_method, :<, :parent_name, :>, :alias_attribute,
      :private_method_defined?, :remove_possible_singleton_method, :module_eval, :rake_extension, :yaml_as,
      :private_class_method, :pretty_print_cycle, :mattr_reader, :cattr_reader, :mattr_writer, :cattr_writer,
      :mattr_accessor, :attr_internal_reader, :attr_internal_writer, :attr_internal_accessor, :attr_internal,
      :redefine_method, :silence_redefinition_of_method, :redefine_singleton_method, :method_visibility, :anonymous?,
      :<=>, :thread_mattr_reader, :thread_cattr_reader, :<=, :>=, :==, :===, :cattr_accessor, :thread_mattr_writer,
      :thread_cattr_writer, :parent, :thread_cattr_accessor, :thread_mattr_accessor, :prepend, :freeze, :inspect,
      :deprecate, :delegate_missing_to, :to_s, :pretty_print, :parents, :autoload, :autoload?, :instance_method,
      :public_instance_method, :const_missing, :guess_for_anonymous, :unloadable, :concerning, :concern, :to_json, :`,
      :to_yaml, :to_yaml_properties, :presence, :blank?, :present?, :psych_to_yaml, :as_json, :in?, :presence_in,
      :acts_like?, :to_param, :to_query, :deep_dup, :duplicable?, :instance_values, :instance_variable_names,
      :with_options, :html_safe?, :is_haml?, :pretty_print_instance_variables, :pretty_print_inspect,
      :require_dependency, :require_or_load, :load_dependency, :try, :try!, :instance_of?, :kind_of?, :is_a?, :tap,
      :public_send, :remove_instance_variable, :singleton_method, :remote_byebug, :debugger, :instance_variable_set,
      :define_singleton_method, :method, :public_method, :extend, :byebug, :pretty_inspect, :to_enum, :enum_for, :gem,
      :suppress_warnings, :=~, :!~, :eql?, :respond_to?, :object_id, :send, :display, :nil?, :hash, :class,
      :singleton_class, :clone, :dup, :itself, :taint, :tainted?, :untaint, :untrust, :untrusted?, :trust, :frozen?,
      :methods, :singleton_methods, :protected_methods, :private_methods, :public_methods, :instance_variable_get,
      :instance_variables, :instance_variable_defined?, :!, :!=, :__send__, :equal?, :instance_eval, :instance_exec,
      :__id__, :titlecase, :titleize
    ]

    def faker_methods
      methods_hash = {}
      Faker.constants.sort.map do |const|
        methods_hash[const] = "Faker::#{const}".constantize.public_methods - IGNORED_FAKER_METHODS
      end
      methods_hash
    end

    def closely_matching_faker_methods(attribute_name)
      possible_method_hash = {}
      faker_methods.each do |fc, fm_array|
        fm_array.map do |fm|
          match_size = (fm.to_s =~ %r{#{attribute_name}})
          if match_size && match_size >= 0
            possible_method_hash[fc] ||= []
            possible_method_hash[fc] << fm
          end
        end
      end
      possible_method_hash
    end

    def find_or_create_factory(name)
      begin
        FactoryBot.factory_by_name(name)
      rescue ArgumentError => e
        puts "#{e.message}\nGenerating new factory for '#{name}'"
        system("rails g factory_bot:model #{singular_table_name.classify.constantize.reflections[name]&.class_name || name.classify}")
      end
    end

    def factory_notation_for_association(association_name)
      find_or_create_factory(association_name)
      if singular_table_name.classify.constantize.reflections[association_name].try(:class_name) == association_name.classify
        association_name
      else
        "association :#{association_name}, factory: :#{singular_table_name.classify.constantize.reflections[association_name].try(:class_name).try(:underscore)}"
      end
    end

    def factory_notation_for_non_association_attr(attr_name, attr_type)
      matching_methods = closely_matching_faker_methods(attr_name)
      value = if matching_methods.present?
        matching_methods = matching_methods.map { |cls, meths| meths.map { |m| "Faker::#{cls}.#{m}" } }.flatten
        s = "{ #{matching_methods.first} }"
        s += " # other possible matching fakers are : #{matching_methods[1..-1].join(' , ')}" if matching_methods.size > 1
        s
      else
        matching_method = default_faker_for_type(attr_type)
        # check if partially (split on underscore) matching method available
        s = matching_method ? "{ #{matching_method} }" : '{ }'
        s += " # TODO: Could not determine appropriate method as per column name."
        s += ' This is default faker as per column type.' if matching_method
        s += " Please use appropriate `Faker::` method"
        s
      end
      "#{attr_name} #{value}"
    end

    def default_faker_for_type(attr_type)
      {
        string: 'Faker::Name.name',
        integer: 'Faker::Number.number',
        float: 'Faker::Number.decimal',
        text: 'Faker::Lorem.paragraph',
        date: 'Faker::Date.backward',
        datetime: 'Faker::Time.backward'
      }[attr_type]
    end

    def factory_attributes
      return '' if self.behavior == :revoke
      attrs = if ActiveRecord::Base.connection.table_exists?(table_name)
        singular_table_name.classify.constantize.columns.reject { |col| ['id', 'created_at', 'updated_at'].include?(col.name) }
      else
        attributes
      end

      attrs.map do |attribute|
        if attribute.name.ends_with?('_id')
          factory_notation_for_association(attribute.name.gsub(/_id/, ''))
        else
          factory_notation_for_non_association_attr(attribute.name, attribute.type)
        end
      end.join("\n")
    end
  end
end