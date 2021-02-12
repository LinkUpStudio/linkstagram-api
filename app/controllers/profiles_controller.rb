class ProfilesController < ApplicationController
  def index
    page = to_int(params[:page])
    page = 0 if Account.page(page).out_of_range?
    profiles =  Account.ordered
    render json: profiles.page(page), status: 200
  end
end
