class PostsController < ApplicationController
  before_action :set_post, only: %i[show update destroy]

  def index
    render json: Post.all, status: 200
  end

  def create
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

  def update
    if @post.update(post_params)
      render json: { message: 'Post successfully updated.' }, status: 200
    else
      render json: { error: 'Unable to update post' }, status: 400
    end
  end

  def destroy
    if @post
      @post.destroy
      render json: { message: 'Post successfully deleted.' }, status: 200
    else
      render json: { error: 'Unable to delete post' }, status: 400
    end
  end

  private

  def post_params
    params.require(:post).permit(:description, :account_id)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
