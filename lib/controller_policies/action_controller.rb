# frozen_string_literal: true

module ControllerPolicies
  # Module containing action controller patches.
  module ActionController
    def inherited(subclass)
      super(subclass)
      subclass.define_method :has_enforced_policies do
        include ControllerPolicies::Enforcement
      end
    end
  end
end
