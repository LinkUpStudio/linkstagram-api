class ProfilesController < ApplicationController
  def index
    profiles = paginate(Account.ordered)
    render json: AccountBlueprint.render(profiles), status: 200
  end

  def show
    profile = Account.find_by_username(params[:username])
    render json: AccountBlueprint.render(profile), status: 200
  end
end
