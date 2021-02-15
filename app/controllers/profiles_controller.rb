class ProfilesController < ApplicationController
  def index
    page = to_int(params[:page])
    page = 0 if Account.page(page).out_of_range?
    profiles = Account.ordered
    render json: AccountBlueprint.render(profiles.page(page), view: :normal), status: 200
  end

  def show
    profile = Account.find(params[:id])
    render json: AccountBlueprint.render(profile, view: :with_posts), status: 200
  end
end
