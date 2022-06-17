class HomeController < ApplicationController
  before_action :check_if_user_login

  def index; end
end
