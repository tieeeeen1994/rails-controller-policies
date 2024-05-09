# frozen_string_literal: true

module ControllerPolicies
  # Module containing action controller patches.
  module ActionControllerPatch
    def has_enforced_policies(&block) # rubocop:disable Naming/PredicateName
      include ControllerPolicies::Enforcement

      return unless block_given?

      define_method(:ability?, &block)
    end

    def no_enforced_policies(arguments = {})
      skip_before_action :check_abilities_by_definition, arguments
    end
  end
end
