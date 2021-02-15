class CommentsController < ApplicationController
  def index
    page = to_int(params[:page])
    page = 0 if Post.page(page).out_of_range?
    comments = Comment.ordered.includes([:commenter])
    render json: CommentBlueprint.render(comments.page(page)), status: 200
  end

  def create
    authenticate
    comment = Comment.new(comment_params)
    comment.commenter = current_user

    if comment.save
      return render json: CommentBlueprint.render(comment), status: 200
    end

    render json: { errors: comment.errors }, status: 422
  end

  private

  def comment_params
    params.require(:comment).permit(:message, :post_id)
  end
end
