class PostFilter
  def call(posts, params)
    username = params[:profile_username]
    posts.by_username(username)
  end
end
