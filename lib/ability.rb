# frozen_string_literal: true

# Ability struct that should house the ability definitions.
class Ability
  attr_reader :code, :name, :description, :actions, :namespace

  # Constructor for Ability object
  # code - The code of the ability (see definitions.rb)
  # name - The name of the ability (see definitions.rb)
  # namespace - The namespace of the ability. You don't need to worry about this.
  # description - The description of the ability (see definitions.rb)
  # actions - The actions that the ability can do (see definitions.rb)
  def initialize(code:, name:, namespace: nil, description: '', actions: [])
    @code = code
    @name = name
    @description = description
    @actions = actions
    @namespace = namespace
  end

  class << self
    alias instantiate new

    # Get all abilities from all definitions.
    def all
      definitions.map { |ability| instantiate(**ability) }
    end

    # Get all ability codes from all definitions.
    # Unused args. Need to allow filtering through namespace.
    def all_codes(_query_string = nil)
      definitions.pluck(:code)
    end

    # Filter abilities based on namespace.
    def where(query)
      case query.class.to_s
      when 'String'
        all.select { |ability| ability.namespace.to_s == trim(query).camelize }
      when 'Module', 'Class'
        all.select { |ability| ability.namespace == query }
      end
    end

    # Find an ability within a namespace.
    def find(query_string)
      where(query_string).first
    end

    # Match abilities based on a matching string or regex. The matcher is based on the namespace.
    def match(expression)
      case expression.class.to_s
      when 'String' then all.select { |ability| ability.namespace.to_s.match?(/#{trim(expression).camelize}/) }
      when 'Regexp' then regex_matcher(expression)
      end
    end

    # Find an ability based on a matching string or regex. The matcher is based on the namespace.
    def mill(expression)
      match(expression).first
    end

    # Path to the policy folder.
    def policy_path
      @policy_path ||= Rails.root.join('app/policies')
    end

    private

    def definitions
      @definitions ||= begin
        data = []
        Dir["#{policy_path}/**/definitions.rb"].each do |file_path|
          data += definition_files_post_processing(file_path)
        end
        data
      end
    end

    def definition_files_post_processing(file_path)
      module_constant = convert_namespace(file_path)
      policy_definitions = module_constant::DEFINITIONS
      policy_definitions.map do |policy_definition|
        policy_definition[:namespace] = module_constant
        policy_definition
      end
    end

    def regex_matcher(expression)
      all.select do |ability|
        ability.namespace.to_s.match?(expression) || ability.namespace.to_s.underscore.match?(expression)
      end
    end

    def trim(namespace)
      namespace.delete_prefix('/').delete_suffix('/')
    end

    def convert_namespace(file_path)
      trim(file_path[policy_path.to_s.length..-4].split('/')[0...-1].join('/')).camelize.constantize
    end
  end
end
