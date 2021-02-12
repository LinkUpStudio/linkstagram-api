class ProfilesController < ApplicationController
  def index
    page = to_int(params[:page])
    profiles = Account.all.order(followers: :desc)
    render json: profiles.page(page), status: 200
  end
end
