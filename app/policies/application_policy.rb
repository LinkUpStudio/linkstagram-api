class AccountPolicy
  attr_reader :user, :account

  def initialize(user, account)
    @user = user
    @account = account
  end

  def update?
    p user.as_json
  end

end
