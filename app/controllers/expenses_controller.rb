class ExpensesController < ApplicationController
  before_action :set_expense, only: [:show, :edit, :update, :destroy]

  # GET /expenses
  # GET /expenses.json
  def index
    expense_details
  end

  # GET /expenses/1
  # GET /expenses/1.json
  def show
    expense_details
  end

  # Show all expenses
  def allexpense
    @months = ["", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    @expense = Expense.all.where(user_id: current_user.id).group_by { |m| m.created_at.month }
    expense_details
  end

  # GET /expenses/new
  def new
    @expense = Expense.new
    expense_details
  end

  # GET /expenses/1/edit
  def edit
    expense_details
  end

  # POST /expenses
  # POST /expenses.json
  def create
    @expense = Expense.new(expense_params)
    @expense.user_id = current_user.id if current_user
    respond_to do |format|
      if @expense.save
        format.html { redirect_to @expense }
        flash[:success] = "Expense was success created."
        format.json { render :show, status: :created, location: @expense }
      else
        format.html { render :new }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expenses/1
  # PATCH/PUT /expenses/1.json
  def update
    respond_to do |format|
      @expense.user_id = current_user.id if current_user
      if @expense.update(expense_params)
        format.html { redirect_to @expense }
        flash[:success] = "Expense was success updated."
        format.json { render :show, status: :ok, location: @expense }
      else
        format.html { render :edit }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1
  # DELETE /expenses/1.json
  def destroy
    @expense.destroy
    respond_to do |format|
      format.html { redirect_to expenses_url }
      format.json { head :no_content }
      flash[:warning] = "Expense was success deleted."
    end
  end

  private


    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expense_params
      params.require(:expense).permit(:title, :amount)
    end

end
