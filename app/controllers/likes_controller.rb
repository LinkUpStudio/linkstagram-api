class LikesController < ApplicationController
  before_action :find_post

  def create
    post.likes.create(account: current_user)
  end

  def destroy
    post.likes.destroy_by(params[:post_id])
  end

  private

  attr_reader :post

  def find_post
    @post = Post.find(params[:post_id])
  end
end
