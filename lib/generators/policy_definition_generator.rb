# frozen_string_literal: true

# Generates a definition file for a namespace.
class PolicyDefinitionGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)
  desc 'Generates a policy definition file based on given namespace.'
  argument :name, type: :string, required: true, desc: 'The namespace for the definition file.'

  def create_policy_definition_file
    return if processed_name.blank?

    template 'definitions.rb', "app/policies/#{processed_name}/definitions.rb"
  end

  private

  def processed_name
    @processed_name ||= name.strip.delete_prefix('/').delete_suffix('/')
  end
end
