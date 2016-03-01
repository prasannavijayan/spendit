class UserBudgetPolicy
  attr_reader :user, :user_budget

  def initialize(user, user_budget)
    @user = user
    @user_budget = user_budget
  end

  def update?
    true
  end
end
