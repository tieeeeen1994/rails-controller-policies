# frozen_string_literal: true

require_relative 'action_controller_patch'
require_relative 'enforcement'

module ControllerPolicies
  # Railtie for Breadcrumb Helper for Rails integration.
  class Railtie < Rails::Railtie
    generators do
      require_relative '../generators/policy_definition_generator'
    end

    initializer 'controller_policies.action_controller' do |app|
      app.reloader.to_prepare do
        ::ActionController::Base.singleton_class.prepend ActionControllerPatch
        ::ActionController::API.singleton_class.prepend ActionControllerPatch
      end
    end

    initializer 'controller_policies.autoloaders' do
      Rails.autoloaders.each do |autoloader|
        autoloader.ignore(Ability.policy_path)
      end

      Dir[Ability.policy_path.join('**/*.rb')].each { |definition| require definition }
    end
  end
end
