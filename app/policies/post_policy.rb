class PostPolicy
  attr_reader :user, :post

  def initialize(user, post)
    @user = user
    @post = post
  end

  def update?
    check_post_owner
  end

  def destroy?
    check_post_owner
  end

  private

  def check_post_owner
    user.id == post.account_id
  end
end
