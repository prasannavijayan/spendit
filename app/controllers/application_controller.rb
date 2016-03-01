class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  before_action :set_user, if: :user_signed_in?
  before_action :set_user_budget, if: :user_signed_in?

  include Pundit

  layout :layout_by_resource

  private
  def set_user
    @user = current_user
  end

  def set_user_budget
    @user_budget = current_user.user_budget
  end

  protected

  def layout_by_resource
    if devise_controller?
      "authentication"
    else
      "application"
    end
  end

end
