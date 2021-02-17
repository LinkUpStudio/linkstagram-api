class PostsController < ApplicationController
  # before_action :set_post, only: %i[show destroy]

  # show Nazar fixing of routes
  def index
    page = to_int(params[:page])
    page = 0 if Post.page(page).out_of_range?
    posts = find_posts
    if posts.any? || Account.exists?(username: params[:profile_username])
      return render json: PostBlueprint.render(posts.page(page)), status: 200
    end

    render json: { errors: 'Invalid username' }, status: 422
  end

  def create
    authenticate
    post = Post.new(post_params)
    post.author = current_user

    params[:photos].each do |photo|
      p = Photo.new
      p.image_data = photo
      p.post = post
      p.save
    end

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

  # attr_reader :post
  #
  def post
    @post ||= Post.find(params[:id])
  end

  def profile
    # @profile ||= Post.find(params[:id])
  end

  def find_posts
    posts = Post.ordered.includes(:author, :photos)
    PostFilter.new.call(posts, params)
  end

  def post_params
    params.require(:post).permit(:description, photos: [])
  end

  # def set_post
  #   @post = Post.find(params[:id])
  # end
end
