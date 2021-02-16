class PostsController < ApplicationController
  before_action :set_post, only: %i[show destroy]

  # show Nazar fixing of routes
  def index
    page = to_int(params[:page])
    page = 0 if Post.page(page).out_of_range?
    posts = Post.ordered.includes([:author])
    posts = posts_by_username(posts)
    if posts.any? || Account.exists?(username: params[:profile_username])
      return render json: PostBlueprint.render(posts.page(page)), status: 200
    end

    render json: { errors: 'Invalid username' }, status: 422
  end

  def create
    authenticate
    post = Post.new(post_params)
    post.author = current_user

    if post.save
      return render json: PostBlueprint.render(post), status: 200
    end

    render json: { errors: post.errors }, status: 422
  end

  def show
    render json: PostBlueprint.render(post), status: 200
  end

  def destroy
    authorize post
    post.destroy
    render json: { message: 'Post successfully deleted.' }, status: 200
  end

  private

  def posts_by_username(posts)
    PostFilter.call(posts, params)
  end

  attr_reader :post

  def post_params
    params.require(:post).permit(:description)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
