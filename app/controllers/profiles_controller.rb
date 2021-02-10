class ProfilesController < ApplicationController
  def index
    render json: Account.all, status: 200
  end
end
