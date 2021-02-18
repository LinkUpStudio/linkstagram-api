class PostsController < ApplicationController
  def index
    page = to_int(params[:page])
    page = 0 if Post.page(page).out_of_range?
    posts = find_posts
    render json: PostBlueprint.render(posts.page(page)), status: 200
  end

  def create
    authenticate
    post = Post.new(post_params)
    post.author = current_user
    p params

    p post_params
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

  def post
    @post ||= Post.find(params[:id])
  end

  def profile
    return unless params[:profile_username]

    @profile ||= Account.find_by_username(params[:profile_username])
  end

  def find_posts
    posts = profile ? profile.posts.includes(:photos) : Post.includes(:author, :photos)
    posts.ordered
  end

  def post_params
    params.require(:post).permit(:description, photos_attributes: [{ image: {} }])
  end
end
