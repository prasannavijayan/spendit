class UserBudgetsController < ApplicationController

  def new
  end

  def create
    @user_budget = UserBudget.new(user_budget_params)
    @user_budget.user_id = current_user.id if current_user
    if params["user_budget"]["month"] == "next"
      budgetmonth = Time.now.strftime("%m").to_i + 1
      @user_budget.budget_date = budgetmonth.to_s + Time.now.year.to_s
    else
      @user_budget.budget_date = Time.now.strftime("%m%Y")
    end
    if @user_budget.save
      flash[:success] = "Budget added for next month"
    else
      flash[:error] = "Please check your budget amount"
    end
    redirect_to expenses_url
  end


  def edit
  end


  private

  def user_budget_params
    params.require(:user_budget).permit(:budget)
  end
end
