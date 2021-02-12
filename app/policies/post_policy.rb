class PostPolicy
  attr_reader :user, :post

  def initialize(user, post)
    @user = user
    @post = post
  end

  def destroy?
    user.id == post.author_id
  end
end
