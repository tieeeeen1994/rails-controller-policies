# frozen_string_literal: true

module ControllerPolicies
  # Railtie for Breadcrumb Helper for Rails integration.
  class Railtie < Rails::Railtie
    generators do
      require_relative '../generators/policy_definition_generator'
    end

    initializer 'controller_policies.action_controller' do |app|
      app.reloader.to_prepare do
        ::ActionController::Base.extend ActionController
        ::ActionController::API.extend ActionController
      end
    end

    initializer 'controller_policies.autoloaders' do
      Rails.autoloaders.each do |autoloader|
        autoloader.ignore(Rails.root.join('app/policies'))
      end

      Dir[Rails.root.join('app/policies/**/*.rb')].each { |definition| require definition }
    end
  end
end
