class CommentsController < ApplicationController
  def index
    comments = paginate(post.comments.ordered.with_commenter)
    render json: CommentBlueprint.render(comments), status: 200
  end

  def create
    authenticate
    comment = Comment.new(comment_params)
    comment.commenter = current_user
    comment.post_id = params[:post_id]

    if comment.save
      return render json: CommentBlueprint.render(comment), status: 200
    end

    render json: { errors: comment.errors }, status: 422
  end

  private

  def post
    @post ||= Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:message)
  end
end
