class PostsController < ApplicationController
  def index
    posts = paginate(find_posts)
    render json: PostBlueprint.render(posts, user: user_or_nil), status: 200
  end

  def create
    authenticate
    post = Post.new(post_params)
    post.author = current_user

    return render json: PostBlueprint.render(post), status: 200 if post.save

    render json: { errors: post.errors }, status: 422
  end

  def show
    render json: PostBlueprint.render(post, user: user_or_nil), status: 200
  end

  def destroy
    authorize post
    post.destroy
    render json: { message: 'Post successfully deleted.' }, status: 200
  end

  private

  def post
    @post ||= Post.find(params[:id])
  end

  def profile
    return unless params[:profile_username]

    @profile ||= Account.find_by_username(params[:profile_username])
  end

  def user_or_nil
    rodauth.session_value ? current_user : nil
  end

  def find_posts
    posts = profile ? profile.posts : Post.with_authors
    posts.ordered.with_photos
  end

  def post_params
    params.require(:post).permit(:description, photos_attributes: [{ image: {} }])
  end
end
