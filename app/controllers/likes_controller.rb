class LikesController < ApplicationController
  before_action :find_post, :authenticate

  def create
    post.likes.create(account: current_user)
  end

  def destroy
    like = post.likes.where(account: current_user)
    unless like.empty?
      return post.likes.destroy_by(account: current_user)
    end

    render json: { error: 'Cannot perform this action' }, status: 422
  end

  private

  attr_reader :post

  def find_post
    @post = Post.find(params[:post_id])
  end
end
