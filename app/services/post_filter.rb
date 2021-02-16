class PostFilter
  def self.call(posts, params)
    username = params[:profile_username]
    username.nil? ? posts : posts.by_username(username)
  end
end