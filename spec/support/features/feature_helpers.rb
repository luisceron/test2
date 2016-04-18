require 'spec_helper'

module FeatureHelpers
  def login(user)
    login_as user, scope: :user
  end
end
