module ApplicationHelper

  # Bootstrap flash messages
  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert alert-#{bootstrap_class_for(msg_type)} alert-dismissible", role: 'alert') do
        concat(content_tag(:button, class: 'close', data: { dismiss: 'alert' }) do
          concat content_tag(:span, '&times;'.html_safe, 'aria-hidden' => true)
          concat content_tag(:span, 'Close', class: 'sr-only')
        end)
        # binding.pry
        message.is_a?(Array) ? concat(message.join('<br>').html_safe) : concat(message)
      end)
      end
    nil
  end

  # Get budget of all time

  def get_budget_by_month_year(month, year)
     #---- important---- Need to check and write for varioud scenarios later
     budget_date = month.to_s + year.to_s
     budget = UserBudget.where(user_id: current_user.id, budget_date: budget_date)
     unless budget.blank?
       return budget.first.budget
     else
       return "0"
     end

  end

  def get_all_month_expenses(month, year)
    # allexpense = Expense.all.group_by { |month| month.created_at.month }
    # Need to check this code for better performance.. This could be a challenging thing to do.
    total_expenses = 0
    get_expense_by_year = Expense.all.where(user_id: current_user.id).group_by { |year| year.created_at.year }
    get_expense_by_months = get_expense_by_year[year].group_by { |month| month.created_at.month }
    expense_of_the_month = get_expense_by_months[month]
    unless expense_of_the_month.nil?
      expense_of_the_month.each do |expense|
        total_expenses = total_expenses + expense.amount
      end
    end

    return total_expenses
  end


end
