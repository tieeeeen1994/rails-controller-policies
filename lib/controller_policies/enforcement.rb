# frozen_string_literal: true

module ControllerPolicies
  # Concern that includes the enforcement of abilities.
  module Enforcement
    extend ActiveSupport::Concern

    included do
      before_action :check_abilities_by_definition

      # Main driver for checking abilities.
      # It is still possible to manually check abilities by calling this method in a controller.
      # Developers need to override this method to implement the own ability checking logic.
      # It needs to accept an ability code and return a boolean.
      def ability?(ability_code) # rubocop:disable Lint/UnusedMethodArgument
        raise AbilityMethodUnimplementedError
      end

      private

      # Automatically check abilities based on definition provided in policies.
      # It has the power to match based on controller, actions and wildcards.
      def check_abilities_by_definition
        applicable_abilities.each do |ability|
          break unless ability?(ability.code)
        end
      end

      # Simply gets the controller namespace.
      def controller_namespace
        @controller_namespace ||= controller_path.split('/')[0...-1].join('/')
      end

      # Method that attempts to go through policy definitions and check if it matches the current controller.
      # If it finds a match, it will be an applicable definition to check abilities for.
      def applicable_abilities
        @applicable_abilities ||= Ability.where(controller_namespace).select do |ability|
          matching_actions = ability.actions.select { |action| /#{action}/.match?("#{controller_path}##{action_name}") }
          matching_actions.present?
        end
      end
    end
  end
end
