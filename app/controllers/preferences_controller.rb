class PreferencesController < ApplicationController

  def show
    expense_details
  end

  def update
    authorize @user
    if params[:user].present?
      @user.update(user_params)
      flash[:success] = 'Profile updated successfully.'
    else
      flash[:success] = 'Please check the errors.'
    end
    expense_details
    render action: 'show'
  end


  private

  def user_params
    params.require(:user).permit(:firstname, :lastname, :budget)
  end

  def expense_details
    @total_expenses = 0
    @expenses = Expense.all.group_by { |m| m.created_at.month }
    @month = Time.current.month
    @date = Time.current
    @current_user = current_user
    @budget = current_user.budget
    # binding.pry
    unless @expenses[2].nil?
      @expenses[2].each do |expense|
        @total_expenses = @total_expenses + expense.amount
      end
    end
    @preferences_id = current_user.id
  end
end
