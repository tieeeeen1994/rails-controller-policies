# frozen_string_literal: true

module ControllerPolicies
  # Module containing action controller patches.
  module ActionController
    def has_enforced_policies # rubocop:disable Naming/PredicateName
      include ControllerPolicies::Enforcement
    end
  end
end
