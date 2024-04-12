# frozen_string_literal: true

require_relative 'controller_policies/version'

raise LoadError, 'The project is not a Rails project!' unless defined?(Rails)

# Base namespace for the gem.
module ControllerPolicies
  # Exception raised for unimplemented ability? method for those including ControllerPolicies::Enforcement.
  class AbilityMethodUnimplementedError < RuntimeError
    def initialize(_msg)
      super('`ability?(ability_code)` method is not implemented')
    end
  end
end

require_relative 'controller_policies/railtie'
