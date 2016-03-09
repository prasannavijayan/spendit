class UserBudgetsController < ApplicationController

  def new
  end

  def create
    @user_budget = UserBudget.new(user_budget_params)
    @user_budget.user_id = current_user.id if current_user
    if params["user_budget"]["month"] == "next"
      budgetmonth = Time.now.strftime("%m").to_i + 1
      @user_budget.budget_date = budgetmonth.to_s + Time.now.year.to_s
      if @user_budget.save
        flash[:success] = "Budget added for next month"
      else
        flash[:error] = "Please check your budget amount"
      end
    else
      @user_budget.budget_date = Time.now.strftime("%m%Y")
      if @user_budget.save
        flash[:success] = "Budget added for this month"
      else
        flash[:error] = "Please check your budget amount"
      end
    end

    redirect_to expenses_url
  end


  def show
    expense_details
  end

  def update
    # @user.id = current_user.id if current_user
    # binding.pry
    respond_to do |format|
      if @user_budget.update(user_budget_params)
        flash[:success] = "User Budget Updated"
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

  def user_budget_params
    params.require(:user_budget).permit(:budget)
  end
end
