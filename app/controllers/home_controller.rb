class HomeController < ApplicationController
  skip_before_action :check_if_user_is_owner
  def index
  end
end
