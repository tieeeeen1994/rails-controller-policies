# Controller Policies

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'controller_policies', '~> 0.1'
```

## Usage

## Generating Definitions

This gem takes advantage of placing all your policy definitions for controllers in one folder (`app/policies`). To generate a policy, run:

```sh
rails g policy_definition my/namespace
```

This will generate a file: `app/policies/my/namespace/definitions.rb`

The developer should edit this file and add the policies for the app. **It is important to note that the location of the definitions file should reflect the namespace of the associated controllers.**

### `actions` key

The `actions` key is an array of strings that contain a list of supported controller actions for automation of policy checking.

For example, you have this definition:

```ruby
module Base
  DEFINITIONS = {
    code: 'policy_code',
    name: 'Policy Name',
    description: 'I am a policy.',
    actions: ['feature_app/users', 'data_app/products#index', 'subscriptions']
  }
end
```

The above definition will have enforced policies on `Base::FeatureApp::UsersController` (all actions), `Base::DataApp::ProductsController` (`index` action) and `Base::SubscriptionController`.

**Do note that the `actions` array implement *Regular Expression Matching*. That means that if you have multiple controllers with the same name on their parent namespace, the parent will be matched first.** To avoid this problem, simply add the namespace to match the intended child instead.

```ruby
module Base
  DEFINITIONS = {
    code: 'policy_code',
    name: 'Policy Name',
    description: 'I am a policy.',
    actions: ['feature_app/users', 'another_base/data_app/products#index', 'base/subscriptions']
  }
end
```

## Adding Policy Enforcement in Controllers

Simply add the line `has_enforced_policies`, and pass a block with one argument (`ability_code`), or override the `ability?(ability_code)` method.

```ruby
class MyController < ApplicationController
  has_enforced_policies do |ability_code|
    render 'unauthorized' unless current_user.abilities.include? ability_code
  end

  # ...
end
```

```ruby
class MyController < ApplicationController
  has_enforced_policies

  def ability?(ability_code)
    render 'unauthorized' unless current_user.abilities.include? ability_code
  end
  # ...
end
```

It is required to use `render` or `redirect_to` within this block **to prevent the controllers from executing the action** when the ability did not exist in the data. The ability checking is done in a `before_action` callback, hence using `render` or `redirect_to` will stop further controller actions. This is a Rails behavior.

Since storing abilities are very flexible and there are truly infinite ways of doing it, *this gem did not support that feature.* Instead, the developer must define their own ability checking.

## Skipping Policy Enforcement in Certain Actions

There might be an event where there is a need to skip automatic policy enforcements in certain actions. As explained above, the policy enforcement is done in a `before_action` callback. To skip a policy enforcement, simply use the `skip_before_action :check_abilities_by_definition` method from Rails. The `:only` and `:except` options are also available to filter actions.

```ruby
class MyOtherController < MyController
  skip_before_action :check_abilities_by_definition, only: [:new, :edit]

  # ...
end
```

## Ability

The Ability class is a model for abilities that come from the definition files.

### Class Methods

#### #all

Get all abilities from all definitions.

#### #all_codes

Get all ability codes from all definitions.

#### #where(query)

Filter abilities based on namespace. `query` can be a String, Module or Class.

#### #find(query)

Find an ability within a namespace. `query` can be a String, Module or Class.

#### #match(expression)

Match abilities based on a matching string or regex. The matcher is based on the namespace. `expression` can be a Regexp or String.

#### #mill(expression)

Find an ability based on a matching string or regex. The matcher is based on the namespace. `expression` can be a Regexp or String.

### Instance Methods

#### #code

The code of the ability.

#### #name

The name of the ability.

#### #description

The description of the ability.

#### #actions

Controller actions that the ability can check against.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tieeeeen1994/controller_policies. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/tieeeeen1994/controller_policies/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ControllerPolicies project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/tieeeeen1994/controller_policies/blob/master/CODE_OF_CONDUCT.md).
