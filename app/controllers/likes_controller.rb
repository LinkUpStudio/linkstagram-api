class LikesController < ApplicationController
  before_action :find_post, :authenticate

  def create
    if post.likes.create(account: current_user)
      return head 200
    end

    render json: { error: 'Cannot perform this action' }, status: 400
  end

  def destroy
    like = post.find_like_by(current_user)
    if like
      like.destroy
      return head 200
    end

    render json: { error: 'Cannot perform this action' }, status: 400
  end

  private

  attr_reader :post

  def find_post
    @post = Post.find(params[:post_id])
  end
end
