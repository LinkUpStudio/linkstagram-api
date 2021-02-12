class PostsController < ApplicationController
  before_action :set_post, only: %i[show destroy]

  def index
    page = to_int(params[:page])
    page = 0 if Post.page(page).out_of_range?
    posts = Post.all.order(created_at: :desc)
    render json: posts.page(page), status: 200
  end

  def create
    authenticate
    post = Post.new(post_params)
    post.author = current_user

    return render json: post, status: 200 if post.save

    render json: { errors: post.errors }, status: 422
  end

  def show
    render json: post, status: 200
  end

  def destroy
    authorize post
    post.destroy
    render json: { message: 'Post successfully deleted.' }, status: 200
  end

  private

  attr_reader :post

  def post_params
    params.require(:post).permit(:description)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
