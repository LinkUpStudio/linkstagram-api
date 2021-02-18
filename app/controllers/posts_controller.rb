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

    # params[:photos].each do |photo|
    #   p = Photo.new
    #   p.image_data = photo
    #   p.post = post
    #   p.save
    # end # nested params

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
    unless params[:profile_username].nil?
      @profile ||= Account.find_by_username(params[:profile_username])
    end
  end

  def find_posts
    posts = Post.ordered.includes(:author) # sense?
    posts = PostFilter.new.call(posts, params) if profile
    posts.includes(:photos)
  end

  def post_params
    params.require(:post).permit(:description, photos_attributes: [:image_data])
  end
end
