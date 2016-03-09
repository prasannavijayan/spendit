class UserPolicy
  attr_reader :user, :expense

  def initialize(user, expense)
    @user = user
    @expense = expense
  end

  def update?
    true
  end
end
