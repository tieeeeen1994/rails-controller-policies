# frozen_string_literal: true

module ControllerPolicies
  # Module containing action controller patches.
  module ActionControllerPatch
    def has_enforced_policies(&block) # rubocop:disable Naming/PredicateName
      include ControllerPolicies::Enforcement

      return unless block_given?

      define_method(:ability?, &block)
    end
  end
end
