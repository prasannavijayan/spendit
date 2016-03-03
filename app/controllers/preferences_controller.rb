class PreferencesController < ApplicationController

  before_filter :set_user

  def show
    expense_details
  end

  def update
    @user.id = current_user.id if current_user
    # binding.pry
    respond_to do |format|
      if @user.update(user_params)
        flash[:success] = "User Settings Updated"
        format.html { redirect_to expenses_url }
        format.json { render :show, status: :ok, location: expenses_url }
      else
        flash[:error] = "Please check your user errors."
        format.html { render :show  }
        format.json { render json: @user.errors, status: :unprocessable_entity}
      end
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:firstname, :lastname, :gender)
  end

  # expense view
  def expense_details
    @user_budget = UserBudget.new
    @months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
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
      @budget = @budget_record.first.budget
    end
  end

  def this_month_budget
    budgetdate = Time.now.strftime("%m%Y").to_i
    @budget_record = UserBudget.where(user_id: current_user.id, budget_date: budgetdate)
    if @budget_record.count == 0
      @this_month_budget = true
    else
      @this_month_budget = false
      @budget = @budget_record.first.budget
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


end
