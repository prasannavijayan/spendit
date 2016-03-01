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
        # format.html { redirect_to @expense, notice: 'Expense was successfully created.' }
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
        # format.html { redirect_to @expense, notice: 'Expense was successfully updated.' }
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
      # format.html { redirect_to expenses_url, notice: 'Expense was successfully destroyed.' }
      format.json { head :no_content }
      flash[:warning] = "Expense was success deleted."
    end
  end

  private

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
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expense_params
      params.require(:expense).permit(:title, :amount)
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
