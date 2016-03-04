class PreferencesController < ApplicationController

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

  def user_params
    params.require(:user).permit(:firstname, :lastname, :gender)
  end

end
