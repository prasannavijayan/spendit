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
    @user_budget = this_month_budget
  end

  # expense view
  def expense_details
    @user_budget = UserBudget.new
    @months = ["", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    next_month_budget
    this_month_budget
    @total_expenses = 0
    @expenses = Expense.all.where(user_id: current_user.id).group_by { |m| m.created_at.month }
    @month = Time.now.month
    @date = Time.now
    @current_user = current_user
    unless @expenses[@month].nil?
      @expenses[@month].each do |expense|
        @total_expenses = @total_expenses + expense.amount
      end
    end
  end

  # Budget
  def next_month_budget
    nextmonth = Time.now.strftime("%m").to_i + 1
    budgetyear = Time.now.year
    budgetdate = nextmonth.to_s + budgetyear.to_s
    @budget_record = UserBudget.where(user_id: current_user.id, budget_date: budgetdate)
    if @budget_record.blank?
       if get_last_week_of_this_month.include? Time.now.strftime("%d %b %Y")
         @next_month_budget = true
       else
         @next_month_budget = false
       end
    else
      @next_month_budget = false
      @budget = @budget_record.first
    end
  end

  def this_month_budget
    budgetdate = Time.now.strftime("%m%Y").to_i
    @budget_record = UserBudget.where(user_id: current_user.id, budget_date: budgetdate)
    if @budget_record.count == 0
      @this_month_budget = true
    else
      @this_month_budget = false
      @budget = @budget_record.first
    end
  end

  # Not the best practise need to check and change the code.
  def get_last_week_of_this_month
    weeklist = []
    for i in 0..5 do
      weeklist << (Date.today.end_of_month - i).strftime("%d %b %Y")
    end
    return weeklist
  end

  def first_two_days_of_this_month
    first_week = []
    for i in 0..2 do
      first_week << (Date.today.end_of_month + i).strftime("%d %b %Y")
    end
    return first_week
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
