class PostsController < ApplicationController
  before_action :set_post, only: %i[show destroy]

  def index
    render json: Post.all, status: 200
  end

  def create
    authenticate
    @post = Post.new(post_params)

    if @post.save
      render json: @post, status: 200
    else
      render json: { error: 'Unable to create post' }, status: 400
    end
  end

  def show
    render json: @post, status: 200
  end

  def destroy
    authorize @post
    @post.destroy
    render json: { message: 'Post successfully deleted.' }, status: 200
  end

  private

  def post_params
    params.require(:post).permit(:description, :account_id)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
